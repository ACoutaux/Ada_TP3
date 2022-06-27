with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Jobs is

    procedure run(J : Job_Callable; R : out Result_Access) is
    begin
        Put ("Initiate job with exec_time");
        Put (Integer(J.Exec_Time),2);
        New_Line;
        delay(J.Exec_Time);
        Put("Job with exec_time ");
        Put(Integer(J.Exec_Time),2);
        Put(" terminated");
        New_Line;
        R := null;
    end run;

end Jobs;

