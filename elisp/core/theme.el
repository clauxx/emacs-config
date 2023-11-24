(setq custom-theme-directory (expand-file-name cl/themes-location user-emacs-directory))
(load-theme 'noir t nil)

(setq-default truncate-lines t
	      global-visual-line-mode t)

(visual-line-mode)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

(add-to-list 'default-frame-alist '(internal-border-width . 32))
(add-to-list 'default-frame-alist '(undecorated . t))

(provide 'theme)
