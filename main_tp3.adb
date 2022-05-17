with Protected_Buffer;
use Protected_Buffer;
with Ada.Text_IO; 
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with ada.numerics.float_random; 
use ada.numerics.float_random;

procedure main_tp3 is 

    read_length: INTEGER;   
    My_File  : File_Type; 
    Items : Shared_Items_Access;
    
    task type Producer;
    task type Consumer;

    task body Producer is

        G : generator;
        f : FLOAT;
        val : INTEGER;

        begin

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
        
    end Producer;

    task body Consumer is 

        val : INTEGER;

        begin
        
        for i in 1 .. 10 loop
            Items.Get (val);
            put("Consumer gets");
            put(val,3);
            New_Line (1);
            delay(1.0);
        end loop;
    end Consumer;

    type Consumer_Access is access Consumer;
    type Producer_Access is access Producer;
     
    P : Producer_Access;
    C : Consumer_Access;

    NC : Natural;
    NP : Natural;

begin

    -- Lecture de la taille du buffer depuis le fichier de parametres
    Open (My_File, In_File, Name => "params.txt");
    Get (My_File, read_length);
    Put("Length read of buffer is ");
    Put(read_length,2);
    New_Line (1);
    Get(My_File, NP);
    Get(My_File, NC);
    Close (My_File);
    Items := new Shared_Items (read_length - 1);
    for I in 1 .. NP loop
      P := new Producer;
    end loop;
    for I in 1 .. NC loop
      C := new Consumer;
    end loop;

end main_tp3;

-- -------------  MODIFS -------------------------
-- Importation params ligne de commande
-- non-blocking / blocking / timed
