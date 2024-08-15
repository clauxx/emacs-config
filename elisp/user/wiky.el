(defun open-read-only-org-buffer (data)
  "Open a new read-only Org mode buffer."
  (interactive)
  (let ((buffer (generate-new-buffer "Read-Only-Org")))
    (with-current-buffer buffer
      (org-mode)
      (insert (string data))
      (setq buffer-read-only t)
      (switch-to-buffer buffer))))

(defvar test-url "https://en.wikipedia.org/w/api.php?action=parse&format=json&page=David_Fincher&prop=wikitext&formatversion=2")

(defun wiky-show ()
  (interactive)
  (request test-url
    ;;:params '(("key" . "value") ("key2" . "value2"))
    :parser 'json-read
    :success (cl-function
	      (lambda (&key data &allow-other-keys)
		(open-read-only-org-buffer data)))))

(provide 'wiky)
