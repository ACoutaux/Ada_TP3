with Runnable;
use Runnable;

procedure main_tp5 is

    core_pool_size : Integer;
    max_pool_size : Integer;
    pool_size : Integer;
    keep_alive_time : Integer;
    period : Integer;
    job_table_size : Integer;


begin

    Open (My_File, In_File, Name => "params_tp5.txt");
    Get (My_File, core_pool_size,max_pool_size,pool_size,keep_alive_time,period,job_table_size);


end main_tp5;