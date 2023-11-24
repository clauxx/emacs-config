(add-to-list 'auto-mode-alist '("/\\.el'" . emacs-lisp-mode))

(add-hook 'emacs-lisp-mode-hook #'smartparens-strict-mode)
(add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

(provide 'elisp-lang)
