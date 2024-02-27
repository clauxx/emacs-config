(use-package clojure-mode
  :demand t)

(use-package cider
  :demand t
  :after clojure-mode
  :hook ((clojure-mode
	  clojurescript-mode
	  cider-repl-mode) . cider-mode)
  :init
  (setq cider-use-overlays t
	cider-repl-display-in-current-window t
	cider-result-overlay-position 'at-point
	clojure-toplevel-inside-comment-form t
	gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024)
	cider-eval-result-prefix "--> "))

(with-eval-after-load 'general
  (general-define-key
   :states 'normal
   :keymaps '(cider-mode-map clojure-mode-map clojurescript-mode-map)
   :prefix cl/sigma-leader
   "r"  '(:ignore t :wk "repl")
   "r r" '(cider-connect-cljs :wk "Connect REPL (cljs)")
   "r R" '(cider-connect-clj :wk "Connect REPL (clj)")
   "e b" '(cider-eval-buffer :wk "REPL eval buffer")
   "e c" '(cider-pprint-eval-last-sexp-to-comment :wk "REPL eval to comment")
   "e f" '(cider-eval-defun-at-point :wk "REPL eval defun")
   "e r" '(cider-pprint-eval-last-sexp-to-repl :wk "REPL eval to repl")
   "e e" '(cider-eval-list-at-point :wk "REPL eval around")))

(provide 'clojure-lang)
