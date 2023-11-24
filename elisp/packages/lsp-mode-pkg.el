(use-package lsp-mode
  :demand t
  :hook ((clojure-mode
	  clojurescript-mode
	  cider-repl-mode) . lsp)
  :init
  (setq lsp-file-watch-threshold 10000
	lsp-enable-which-key-integration t))

(use-package lsp-ui
  :demand t
  :hook (lsp-mode . lsp-ui-mode)
  :init
  (setq lsp-ui-sideline-show-diagnostics t
	lsp-ui-doc-position 'at-point
	lsp-ui-doc-enable 1)
  :config
  (lsp-ui-sideline-mode))

(use-package flycheck
  :demand t)

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual)
   :keymaps 'override
   "g D" 'lsp-ui-peek-find-definitions
   "g r" 'lsp-ui-peek-find-references
   "g R" 'lsp-rename
   "?"  'lsp-ui-doc-glance
   "C-/" 'lsp-ui-doc-focus-frame))

(provide 'lsp-mode-pkg)
