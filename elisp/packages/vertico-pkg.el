(use-package vertico
  :demand t
  :bind (:map vertico-map
	      ("<escape>" . abort-recursive-edit)
	      ("?" . minibuffer-completion-help)
	      ("TAB" . vertico-next)
	      ("§" . vertico-previous)
	      ("M-j" . vertico-next)
	      ("M-k" . vertico-previous)
	      ("M-TAB" . minibuffer-complete))
  :hook ('minibuffer-setup-hook . cursor-intangible-mode)
  :init
  (setq vertico-cycle t
	enable-recursive-minibuffers t
	vertico-posframe-poshandler #'posframe-poshandler-frame-top-center
	minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
  (vertico-mode))

(use-package vertico-posframe
  :after vertico
  :demand t
  :custom-face
  (vertico-posframe-border ((t (:background "#5A7D7C"))))
  (vertico-posframe ((t (:background "#5A7D7C"))))
  :init
  (setq vertico-posframe-border-width 24
	vertico-posframe-width 140)
  :config 
  (evil-set-initial-state 'vertico-posframe-mode 'emacs)
  (vertico-posframe-mode 1))

(provide 'vertico-pkg)
