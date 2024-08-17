(use-package lsp-mode
  :hook ((clojure-mode
	  clojurescript-mode
	  cider-repl-mode
	  rustic-mode
	  nix-mode
	  go-mode) . lsp)
  :init
  (setq lsp-file-watch-threshold 10000
	lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :init
  (setq lsp-ui-sideline-show-diagnostics t
	lsp-ui-doc-position 'at-point
	lsp-ui-doc-enable 1)
  :config
  (lsp-ui-sideline-mode))

(use-package flycheck)
(use-package flycheck-projectile
  :after 'flycheck)

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual)
   :keymaps 'override
   "g D" 'lsp-find-definition
   "g r" 'lsp-find-references
   "g R" 'lsp-rename
   "g a" 'lsp-execute-code-action
   "?"  'lsp-ui-doc-glance
   "C-/" 'lsp-ui-doc-focus-frame))

(provide 'lsp-mode-pkg)
