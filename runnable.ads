with main_tp3;
use main_tp3;

package Runnable is

   type Runnables is tagged record
      Exec_Time : Duration;
   end record;

    procedure Run (R : Runnables);

end Runnable;
