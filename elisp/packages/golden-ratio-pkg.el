(use-package golden-ratio
  :demand t
  :config
  (golden-ratio-mode 1)
  (setq golden-ratio-auto-scale t
	golden-ratio-adjust-factor .8
	golden-ratio-wide-adjust-factor .8
	golden-ratio-max-width 72
	golden-ratio-extra-commands
	(append golden-ratio-extra-commands
		'(evil-window-left
		  evil-window-right
		  evil-window-up
		  evil-window-down))))

(provide 'golden-ratio-pkg)
