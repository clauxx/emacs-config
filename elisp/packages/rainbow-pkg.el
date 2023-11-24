(use-package rainbow-delimiters
  :demand t
  :ensure t
  :hook 
  ((org-mode
    prog-mode
    elisp-mode
    clojure-mode
    clojurescript-mode
    cider-repl-mode) . rainbow-delimiters-mode))

(provide 'rainbow-pkg)
