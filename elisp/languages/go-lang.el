(use-package go-mode
  :demand t
  :hook (go-mode-hook . lsp-deferred)
  :hook (go-mode-hook . lsp))

(use-package go-eldoc
  :demand t
  :hook (go-mode-hook . go-eldoc-setup))

(provide 'go-lang)
