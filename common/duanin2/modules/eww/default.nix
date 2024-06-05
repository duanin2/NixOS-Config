{ lib, pkgs, customPkgs, ... }: {
  xdg.configFile."eww/eww.yuck" = {
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

(deflisten batteries :initial "[]"
	         `${lib.getExe customPkgs.scripts.battery}`)
(defwidget batteryIcons []
           (box (for battery in batteries
	                   (batteryIcon :name {battery.name}
			                            :capacity {battery.capacity}
			                            :health {battery.health}
			                            :remainTime {battery.remainTime}
			                            :icon {battery.icon}))))
(defwidget batteryIcon [name capacity health remainTime icon]
	         (tooltip
                    (box :orientation "vertical"
                         (label :text {name})
                         (label :text {"Capacity: " + capacity + " %"})
                         (label :text {"Remaining time: " + remainTime})
                         (label :text {"Health: " + health + " %"}))
           (label :text {icon})))

(defwidget networkIcon []
           (button :onclick "true"
	                 :style "background: inherit"))

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
				                                   :max 188
				                                   :height 100
				                                   :flipped true
				                                   :onchange "${lib.getExe pkgs.brightnessctl} -s s {}; ${lib.getExe pkgs.eww} update brightness={}"
				                                   :round-digits 0
				                                   :value {brightness}
				                                   :tooltip {"Brightness: " + round(brightness / 187 * 100, 0)}))
		                      (label :text "󰃠"
			                           :tooltip {"Brightness: " + round(brightness / 187 * 100, 0)}))))


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
				                                   :max 101
				                                   :height 100
				                                   :flipped true
				                                   :onchange "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ {}%; ${lib.getExe pkgs.eww} update volume={}"
				                                   :round-digits 0
				                                   :value {volume}
				                                   :tooltip {"Volume: " + volume}))
		                      (label :text "󰃠"
			                           :tooltip {"Volume: " + volume}))))

;; (defwidget scaleReveal [?min max current onchange revealed tooltip]
;;            (eventbox :onhover "${lib.getExe pkgs.eww} update volReveal=true"
;; 	                   :onhoverlost "${lib.getExe pkgs.eww} update volReveal=false"
;; 	                   (box :orientation "vertical"
;; 		                      (revealer :transition "slideup"
;; 			                              :reveal volReveal
;; 			                              :duration "200ms"
;; 			                              (scale :orientation "vertical"
;; 				                                   :min 0
;; 				                                   :max 101
;; 				                                   :height 100
;; 				                                   :flipped true
;; 				                                   :onchange "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ {}%; ${lib.getExe pkgs.eww} update volume={}"
;; 				                                   :round-digits 0
;; 				                                   :value {volume}
;; 				                                   :tooltip {"Volume: " + volume}))
;; 		                      (label :text "󰃠"
;; 			                           :tooltip {"Volume: " + volume}))))
;;
;; (defpoll volume :initial "{volumeLeft:0,volumeRight:0,mute:true,sinks:[],sources:[]}"
;;                 :interval "1s"
;;                 `echo "{volumeLeft:0,volumeRight:0,mute:true,sinks:[],sources:[]}"`)
;; (defwidget volume [])
;; (defpoll brightness :initial "{brightness:0,maxBrightness:0,minBrightness:0}"
;; 	                  :interval "1s"
;; 	                  `echo "{brightness:0,maxBrightness:0,minBrightness:0}"`)
    '';
  };

  systemd.user = {
    services = let
      generalScript = name: params: customPkgs.systemdScript name "${lib.getExe pkgs.eww} ${params}"; 
    in {
      "eww-daemon" = {
        Unit = {
          Description = "The EWW Daemon";
          After = [ "graphical-session.target" ];
        };
        Service = let
          script = action: params: generalScript "eww-daemon-${action}" "${params} --no-daemonize";
        in {
          Type = "exec";
          ExitType = "main";
          OOMPolicy = "stop";
          ExecStart = script "start" "daemon";
          ExecReload = script "reload" "reload";
          ExecStop = script "stop" "kill";
        };
      };
      "eww-bar" = let
        script = action: params: generalScript "eww-bar-${action}" "${params} myBar";
      in {
        Unit = {
          Description = "My EWW Bar";
          Wants = [ "eww-daemon.service" ];
          After = [ "eww-daemon.service" ];
          Before = [ "tray.target" ];
        };
        Install = {
          WantedBy = [ "tray.target" ];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          OOMPolicy = "continue";
          ExecStart = script "start" "open";
          ExecStop = script "stop" "close";
        };
      };
    };
    targets = {
      "tray.target" = {
        Unit = {
          WantedBy = [ "xdg-desktop-autostart.target" ];
          Before = [ "xdg-desktop-autostart.target" ];
        };
      };
    };
  };
}
