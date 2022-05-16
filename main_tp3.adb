with Protected_Buffer;
use Protected_Buffer;
with Ada.Text_IO; 
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with ada.numerics.float_random; 
use ada.numerics.float_random;

procedure main_tp3 is 

    read_length, cpt_loop_p, cpt_loop_c : INTEGER;   
    My_File  : FILE_TYPE; 
    my_buf : Shared_Items;
    
    task type Producer;
    task type Consumer;

    task body Producer is

        G : generator;
        f : FLOAT;
        val : INTEGER;

        begin
        cpt_loop_p := 0;

        loop      
            exit when cpt_loop_p = 10;
            delay(1.0);
            reset(G);
            f := Random(G); -- test à 1
            val := Integer(f*10.0);
            my_buf.Set(val);
            put("Producers puts"); 
            put(val,3);
            New_Line (1);
            cpt_loop_p := cpt_loop_p + 1;       
        end loop;
        
    end Producer;

    task body Consumer is 

        val : INTEGER;

        begin
        cpt_loop_c := 0;
        
        loop
        exit when cpt_loop_c = 10;
            cpt_loop_c := cpt_loop_c + 1;
            delay(1.0);
            my_buf.Get (val);
            put("Consumer gets");
            put(val,3);
            New_Line (1);
        end loop;
    end Consumer;

    type C is access Consumer;
    type P is access Producer;
     
    P1 : P := new Producer;
    C1 : C := new Consumer;

begin

    -- Lecture de la taille du buffer depuis le fichier de parametres
    Open (My_File, In_File, Name => "params.txt");
    Get (My_File, read_length);
    Put("Length read of buffer is ");
    Put(read_length,2);
    New_Line (1);
    Close (My_File);
    Protected_Buffer.Length := read_length;


end main_tp3;

-- -------------  MODIFS -------------------------
-- Importation params
