(in-package :nlgame)

(defmacro repl-continuable (&body body)
  "Allow debugger to continue execution from errors."
  `(restart-case (progn ,@body)
     (continue () :report "Continue")))

(defun repl-update ()
  "Handle REPL requests."
  #+swank
  (repl-continuable
    (let ((connection (or swank::*emacs-connection*
                          (swank::default-connection))))
      (when connection
        (swank::handle-requests connection t)))))
