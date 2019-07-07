(defun f()
  "something"
  (interactive)
  (insert "if err != {\n\t\n}")
  (backward-char 2))

(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e4446")
(global-hl-line-mode 0)

(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))


(defun get-go-test-filename ()
  (format "%s_test.go" buffer-file-name))

(defun run-test-with-cover ()
  (interactive)
  (shell-command
   (format "/usr/local/go/bin/go test %s -coverprofile=/tmp/go-test-emacs.out"
	   default-directory)))

					; name.go:line.column,line.column numberOfStatements count

(defun split-fields (line)
    (setq fields (split-string line "[:,\s]")))

(defun get-filename (f) (car f))

(defun is-tested (f) (last f))

(defun get-linenos (f)
  (when (length f)
    (list
     (truncate (string-to-number (nth 1 f)))
     (truncate (string-to-number (nth 2 f))))))

(defun cover-highlight ()
  (interactive)
  (run-test-with-cover)
  (setq lines (read-lines "/tmp/go-test-emacs.out"))
  (while lines
    (setq fields (split-fields (pop lines)))
    (setq filename (get-filename fields))
    (setq block (get-linenos fields))
					;    (when (and (is-not-tested fields) (eq filename (buffer-file-name)))
    (when (is-tested fields)
      (message "here")
      (highlight (pop block) (pop block)))))
    
(defun pos-at-line-col (l c)
  (save-excursion
    (goto-char (point-min))
    (forward-line l)
    (move-to-column c)
    (point)))

(defun highlight (start end)
  (setq x (make-overlay (pos-at-line-col start 0) (pos-at-line-col end 0)))
  (overlay-put x 'face '(:background "blue"))
  '(x))

(defun cover-highlight-stop ()
  (interactive)
  (remove-overlays))
