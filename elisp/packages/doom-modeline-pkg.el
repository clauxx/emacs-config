(use-package doom-modeline
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-height 40
	doom-modeline-minor-modes nil
	doom-modeline-vcs-max-length 50
	doom-modeline-enable-word-count t))

(provide 'doom-modeline-pkg)
