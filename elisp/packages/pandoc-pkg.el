(use-package pandoc-mode
  :demand t
  :hook (markdown-mode-hook . pandoc-mode))

(provide 'pandoc-pkg)
