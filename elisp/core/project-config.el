(setq status-ios-buffer "*Status: run-ios*")
(setq status-android-buffer "*Status: run-android*")
(setq status-clojure-buffer "*Status: shadow-cljs*")
(setq status-metro-buffer "*Status: metro*")

(add-to-list 'display-buffer-alist '(status-clojure-buffer . (display-buffer-no-window . nil)))
(add-to-list 'display-buffer-alist '(status-metro-buffer . (display-buffer-no-window . nil)))

(provide 'project-config)
