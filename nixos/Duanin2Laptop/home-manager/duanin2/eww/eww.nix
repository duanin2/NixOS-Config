{ config, pkgs, tasks, menu, ... }: ''
(defwindow bar
           :monitor 0
           :geometry (geometry :x "0%"
                               :y "0%"
                               :width "100%"
                               :height "32px"
                               :anchor "bottom center")
           :stacking "fg"
           :exclusive true
           (centerbox :orientation "h"
                      :halign "fill"
                      :space-evenly false
                      (left)
                      (center)
                      (right)))

(defwidget left []
           (box :space-evenly false
                :spacing 6
                :orientation "h"
                :halign "start"
                (start-button)
                (taskbar)))
(defwidget center []
           (box :space-evenly false
                :orientation "h"
                :halign "center"))
(defwidget right []
           (box :space-evenly false
                :orientation "h"
                :halign "end"
								(systray :pack-direction "rtl")
                (sys)))

(defwidget start-button []
           (button :onclick "true"
                   :style "padding: 2px 6px;"
                   (box :space-evenly false
                        :spacing 6
                        (image :path "${config.home.homeDirectory}/.local/share/eww/images/start-logo.png"
                               :image-width 24
                               :image-height 24)
                        (label :text "Start"
                               :limit-width 6
                               :show-truncated true))))

(deflisten taskbar-content :initial "(box :space-evenly false)"
                         "${tasks}")
(defwidget taskbar []
           (box (for entry in taskbar-content
                     (taskbar-task :focused {entry.isFocused}
                                   :focus {entry.focus}
                                   :minimize {entry.minimize}
                                   :close {entry.close}
                                   :title {entry.title}))))
(defwidget taskbar-task [focused focus minimize close title]
           (button :class {focused ? "taskbar-task focused" : "taskbar-task"}
                   :width 150
                   :onclick focus
                   :onmiddleclick minimize
                   :onrightclick close
                   :tooltip title
                   (label :text title
                          :limit-width 23
                          :show-truncated true
                          :halign "start"
                          :style "font-family: monospace; font-size: 9px;")))

(defpoll time :interval "1s"
         "date +\"%H:%M:%S\"")
(defpoll date :interval "1m"
         "date +\"%-d. %-m. %-Y\"")
(defwidget sys []
           (box :space-evenly true
                :spacing 2
                :orietation "h"
                (box :orientatation "h"
                     :space-evenly false
                     (label :text time
                            :valign "start"
                            :style "font-family: monospace; font-size: 10px; padding: 0; margin: 0;")
                     (label :text date
                            :valign "end"
                            :style "font-family: monospace; font-size: 10px; padding: 0; margin: 0;"))))
(defwidget sys-icon [path ?tooltip ?onclick ?onmiddleclick ?onrightclick]
           (button :onclick {onclick || "true"}
                   :onmiddleclick {onmiddleclick || "true"}
                   :onrightclick {onrightclick || "true"}
                   :tooltip tooltip
                   (image :path path
                          :image-height 16
                          :image-width 16)))
(defwidget sys-text [text ?tooltip ?onclick ?onmiddleclick ?onrightclick]
           (button :onclick {onclick || "true"}
                   :onmiddleclick {onmiddleclick || "true"}
                   :onrightclick {onrightclick || "true"}
                   :tooltip tooltip
                   (label :text text)))
''