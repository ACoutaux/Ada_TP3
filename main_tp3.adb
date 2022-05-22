with Protected_Buffer;
use Protected_Buffer;
with Ada.Text_IO; 
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with ada.numerics.float_random; 
use ada.numerics.float_random;
with Ada.Calendar;
use Ada.Calendar;

procedure main_tp3 is 

    timed_delay : DURATION := 2.0; -- en secondes
    current_time : TIME := Clock;
    next_time : TIME := current_time + timed_delay;

    read_length : INTEGER;   
    My_File  : File_Type; 
    Items : Shared_Items_Access;
    
    Buffer_size : Natural;

    task type Producer is 
        entry non_blocked;
        entry blocked;
        entry timed;
    end Producer;

    task type Consumer is
        entry non_blocked;
        entry blocked;
        entry timed;
    end Consumer;


    task body Producer is

        G : generator;
        f : FLOAT;
        val : INTEGER;

        begin

        select
            accept non_blocked do
                for i in 1 .. 10 loop
                    reset(G);
                    f := Random(G);
                    val := Integer(f*10.0);
                    Items.Set(val);
                    put("Producers puts"); 
                    put(val,3);
                    New_Line (1);
                    delay(1.0);   
                end loop;
            end non_blocked;
        or
            accept blocked do
                for i in 1 .. 10 loop
                    reset(G);
                    f := Random(G);
                    val := Integer(f*10.0);
                    Items.Get(Buffer_size);
                    while Buffer_size < Items.Length loop
                        null;
                    end loop;
                    Items.Set(val);
                    put("Producers puts"); 
                    put(val,3);
                    New_Line (1);
                    delay(1.0);   
                end loop;
            end blocked;
        or
            accept timed do
                for i in 1 .. 10 loop
                    reset(G);
                    f := Random(G);
                    val := Integer(f*10.0);
                    Items.Get_size (Buffer_size);
                    delay until next_time; --Buffer_size < Items.Length or 
                    Items.Set(val);
                    put("Producers puts"); 
                    put(val,3);
                    New_Line (1);
                    delay(1.0);   
                end loop;
            end timed;
        end select;
        
    end Producer;

    task body Consumer is 

        val : INTEGER;

        begin

        select

            accept non_blocked do
        
                for i in 1 .. 10 loop
                    Items.Get (val);
                    put("Consumer gets");
                    put(val,3);
                    New_Line (1);
                    delay(1.0);
                end loop;
            end non_blocked;
        or 
            accept blocked do
                for i in 1 .. 10 loop
                    Items.Get_size (Buffer_size);
                    while Buffer_size > 0 loop
                        Items.Get_size(Buffer_size);
                    end loop;
                    Items.Get (val);
                    put("Consumer gets");
                    put(val,3);
                    New_Line (1);
                    delay(1.0);
                end loop;
            end blocked;
        or
            accept timed do
                for i in 1 .. 10 loop
                    Items.Get_size (Buffer_size);
                    delay until next_time; -- or Buffer_size > 0 
                    Items.Get (val);
                    put("Consumer gets");
                    put(val,3);
                    New_Line (1);
                    delay(1.0);
                end loop;
            end timed;
        end select;
    end Consumer;

    type Consumer_Access is access Consumer;
    type Producer_Access is access Producer;
     
    P : Producer_Access;
    C : Consumer_Access;

    number_consumers : Natural;
    number_producters : Natural;
    mode : INTEGER;

begin

    -- Lecture de la taille du buffer depuis le fichier de parametres
    Open (My_File, In_File, Name => "params.txt");
    Get (My_File, read_length); -- taille du buffer 1e ligne fichier params
    Put("Length read of buffer is ");
    Put(read_length,2);
    New_Line (1);
    Get(My_File, number_producters); -- nombre de producteurs 2e ligne fichier params
    Get(My_File, number_consumers); -- nombre de consommateurs 3e ligne fichier params
    Get(My_File, mode); -- mode non-blocked(0), blocked(1), timed(2) 4e ligne fichier params
    Close (My_File);
    Items := new Shared_Items (read_length - 1);
    
    for I in 1 .. number_producters loop
      P := new Producer;
      P.non_blocked;
    end loop;
    for I in 1 .. number_consumers loop
      C := new Consumer;
      C.non_blocked;
    end loop;

end main_tp3;

-- -------------  MODIFS -------------------------
-- Importation params ligne de commande
-- non-blocking / blocking / timed
