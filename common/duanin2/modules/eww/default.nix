{ pkgs, customPkgs, ... }: {
  xdg.configFile."eww/scripts/eww.yuck" = {
    enable = true;

    executable = false;
    text = ''
(defwindow myBar
    :monitor 0
    :geometry (geometry
	       :x "5px"
	       :y "0%"
	       :width "40px"
	       :height "98.5%"
	       :anchor "center right")
    :stacking "fg"
    :exclusive true
    :reserve (struts :distance "50px" :side "right")
    :windowtype "dock"
    :wm-ignore false
    (bar))


(defwidget bar []
  (centerbox :orientation "vertical"
	     :valign "baseline"
	     :halign "baseline"
	     :vexpand true
	     :hexpand true
	     (top)
	     (center)
	     (bottom)))


(defwidget top []
  (box :orientation "vertical"
       :valign "start"
       :halign "center"
       :vexpand true
       :hexpand true
       :spacing 10
       :space-evenly false
       (launchButton)))
(defwidget center []
  (box :orientation "vertical"
       :valign "center"
       :halign "center"
       :vexpand true
       :hexpand true
       :spacing 10
       :space-evenly false
       ))
(defwidget bottom []
  (box :orientation "vertical"
       :valign "end"
       :halign "center"
       :vexpand true
       :hexpand true
       :spacing 10
       :space-evenly false
       (systray :spacing 2
		:halign "center"
		:orientation "vertical"
		:icon-size 24)
       (batteryIcons)
       (networkIcon)
       (brightness)
       (volume)
       (clock)))


(defwidget clock []
  (box :orientation "vertical"
       :spacing 5
       :space-evenly false
       :halign "center"
       :hexpand true
       :tooltip {formattime(EWW_TIME, "%c")}
       :style "font-size: 16px; font-family: FiraCode Nerd Font Propo;"
       (label :text {formattime(EWW_TIME, "%H")})
       (label :text {formattime(EWW_TIME, "%M")})))

(defwidget launchButton []
  (button :onclick "true"
	  :style "background: inherit"
	  (label :text "󱄅"
		 :style "font-size: 24px; padding: 0; margin: 0;"
		 :xalign 0.5
		 :yalign 0.5)))

(defpoll batteries :initial "[]"
	 :interval "2s"
	 `${customPkgs.scripts.battery}`)
(defwidget batteryIcons []
  (box (for battery in batteries
	    (batteryIcon :name {battery.name}
			 :capacity {battery.capacity}
			 :health {battery.health}
			 :remainTime {battery.remainTime}
			 :icon {battery.icon}))))
(defwidget batteryIcon [name capacity health remainTime icon]
	   (label :text {icon}
		  :tooltip {"Battery " + name + ": " + capacity + " %"}))

(defwidget networkIcon []
  (button :onclick "true"
	  :style "background: inherit"
	  ))

(defpoll brightness :initial 0
	 :interval "1s"
	 `${lib.getExe pkgs.brightnessctl} g -qm`)
(defvar brightReveal false)
(defwidget brightness []
  (eventbox :onhover "${lib.getExe pkgs.eww} update brightReveal=true"
	    :onhoverlost "${lib.getExe pkgs.eww} update brightReveal=false"
	    (box :orientation "vertical"
		 (revealer :transition "slideup"
			   :reveal brightReveal
			   :duration "200ms"
			   (scale :orientation "vertical"
				  :min 0
				  :max 187
				  :height 100
				  :flipped true
				  :onchange "${lib.getExe pkgs.brightnessctl} -s s {}; ${lib.getExe pkgs.eww} update brightness={}"
				  :round-digits 0
				  :value {brightness}
				  :tooltip "Brightness: " + {round(brightness / 187 * 100)}))
		 (label :text "󰃠"
			:tooltip "Brightness: " + {round(brightness / 187 * 100)}))))


(defpoll volume :initial 0
	 :interval "1s"
	 `${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | awk -F '/' '{ print $2 }' | sed -e 's/ //g' -e 's/%//g'`)
(defvar volReveal false)
(defwidget volume []
  (eventbox :onhover "${lib.getExe pkgs.eww} update volReveal=true"
	    :onhoverlost "${lib.getExe pkgs.eww} update volReveal=false"
	    (box :orientation "vertical"
		 (revealer :transition "slideup"
			   :reveal volReveal
			   :duration "200ms"
			   (scale :orientation "vertical"
				  :min 0
				  :max 100
				  :height 100
				  :flipped true
				  :onchange "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ {}%; ${lib.getExe pkgs.eww} update volume={}"
				  :round-digits 0
				  :value {volume}
				  :tooltip {"Volume: " + volume}))
		 (label :text "󰃠"
			:tooltip "Brightness: " + {round(brightness / 187 * 100)}"))))
    '';
  };
}
