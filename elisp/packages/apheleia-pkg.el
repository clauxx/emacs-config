(use-package apheleia
  :demand t
  :init
  (setq apheleia-log-only-errors nil)
  (setq apheleia-mode-alist
        '((clojure-mode . zprint)
          (clojurescript-mode . zprint)
          (css-mode . prettier)
          (css-ts-mode . prettier)
          (elixir-mode . mix-format)
          (emacs-lisp-mode . lisp-indent)
          (go-mode . gofmt)
          (go-ts-mode . gofmt)
          (html-mode . prettier)
          (java-mode . google-java-format)
          (js-mode . prettier)
          (json-mode . prettier)
          (json-ts-mode . prettier)
          (ledger-mode . ledger)
          (nix-mode . nixfmt)
          (python-mode . black)
          (ruby-mode . prettier)
          (rust-mode . rustfmt)
          (rustic-mode . rustfmt)
          (sass-mode . prettier)
          (terraform-mode . terraform)
          (typescript-mode . prettier)
          (typescript-tsx-mode . prettier)
          (web-mode . prettier)
          (yaml-mode . prettier)))

  (setq apheleia-formatters
        `((black . ("black" "-"))
          (gofmt . ("gofmt"))
          (gofumpt . ("gofumpt"))
          (google-java-format . ("google-java-format" "-"))
          (ledger . pkg-apheleia/formatter-ledger)
          (lisp-indent . apheleia-indent-lisp-buffer)
          (mix-format . ("mix" "format" "-"))
          (nixfmt . ("nixfmt"))
          (ocamlformat . (ocamlformat . ("ocamlformat" "-" "--name" filepath "--enable-outside-detected-project")))
          (rustfmt . ("rustfmt" "--quiet" "--emit" "stdout"))
          (terraform . ("terraform" "fmt" "-"))
          (zprint "zprint" "{:search-config? true}")))
  (apheleia-global-mode t))

(provide 'apheleia-pkg)
