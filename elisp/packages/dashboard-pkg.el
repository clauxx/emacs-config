(use-package dashboard
  :demand t 
  :init
  (setq initial-buffer-choice 'dashboard-open
	dashboard-set-file-icons t
	dashboard-banner-logo-title "Emacs Is More Than A Text Editor!"
	dashboard-center-content nil
	dashboard-projects-backend 'project-el
	dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (projects . 3)))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-mode))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "o h" '(dashboard-open :wk "Open dashboard")))

(provide 'dashboard-pkg)
