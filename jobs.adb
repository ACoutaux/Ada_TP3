package body Jobs is

    procedure run(J : Job_Callable; R : out Result_Access) is
    begin
        delay(J.Exec_Time);
        R := null;
    end run;

end Jobs;

