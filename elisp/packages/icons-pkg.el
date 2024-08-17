;; (use-package all-the-icons
;;   :demand t
;;   :if (display-graphic-p))

;; (use-package all-the-icons-dired
;;   :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package nerd-icons
  :if (display-graphic-p))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(provide 'icons-pkg)
