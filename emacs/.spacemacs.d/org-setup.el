;; Set the directory for org-agenda files
(setq org-agenda-files '("~/repos/pers/notes/org"))
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 2))))
(setq org-default-notes-file "~/repos/pers/notes/org/inbox.org")

(setq org-capture-templates
      '(("s" "Schedule task to inbox" entry
         (file+headline "~/repos/pers/notes/org/inbox.org" "Inbox")
         "* TODO [#3] %?\12SCHEDULED: %t" :jump-to-captured nil)))

(setq org-agenda-custom-commands
      '(("t" "Today's Scheduled Tasks"
         ((agenda "" ((org-agenda-span 1)  ; Only show today
                      (org-agenda-start-on-weekday nil)))))))

(setq org-global-properties
      '(("Effort_ALL" . "0:05 0:10 0:15 0:30 0:45 1:00 1:30 2:00 3:00 4:00 5:00 6:00 7:00")))
(setq org-columns-default-format
      "%40ITEM(Task) %17Effort(Estimated Effort){:} %10CLOCKSUM_T(Time Spent)")

(setq org-capture-use-agenda-date t)
(setq org-agenda-show-future-repeats nil)

(require 'org)
(require 'org-clock)

;; usage: emacsclient -e "(my/print-active-clock)"
(defun my/print-active-clock ()
  ;; Call org-clock-get-clock-string without properties for use in xbar/Kargos
  (if (org-clock-is-active)
      (org-no-properties (org-clock-get-clock-string))))

(defun my/org-capture-frame-setup ()
  "Set up a clean frame for Org Capture."
  (when (string= (frame-parameter nil 'name) "capture")
    ;; Delete all other windows in the frame
    (delete-other-windows)))

(add-hook 'org-capture-mode-hook #'my/org-capture-frame-setup)

(defun my/make-org-capture-frame (key)
  "Create a new frame and start org-capture with the template KEY."
  (let ((frame (make-frame '((name . "capture")
                             (width . 80)
                             (height . 20)))))
    (select-frame-set-input-focus frame)
    (org-capture nil key)))

(defun my/delete-capture-frame ()
  "Delete the 'capture' frame once Org Capture is finished."
  (when (string= (frame-parameter nil 'name) "capture")
    (delete-frame)))

(add-hook 'org-capture-after-finalize-hook #'my/delete-capture-frame)
