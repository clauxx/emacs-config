(use-package go-mode
  :hook (go-mode-hook . lsp-deferred)
  :hook (go-mode-hook . lsp))

(use-package go-eldoc
  :hook (go-mode-hook . go-eldoc-setup))

(provide 'go-lang)
