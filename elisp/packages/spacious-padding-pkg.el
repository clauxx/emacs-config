(use-package spacious-padding
  :init
  (setq spacious-padding-widths '( :internal-border-width 20
				   :header-line-width 4
				   :mode-line-width 6
				   :tab-width 4
				   :right-divider-width 30
				   :scroll-bar-width 8))

  :config
  (spacious-padding-mode 1))

(provide 'spacious-padding-pkg)
