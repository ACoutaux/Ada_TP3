with Protected_Buffer;
use Protected_Buffer;
with Ada.Text_IO; 
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with ada.numerics.float_random; 
use ada.numerics.float_random;

procedure main_tp3 is 

    read_length, cpt_loop : INTEGER;   
    My_File  : FILE_TYPE; 
    my_buf : Shared_Items;
    
    task type Producer;
    task type Consumer;

    task body Producer is

        G : generator;
        f : FLOAT;
        val : INTEGER;

        begin
        reset(G);
        f := Random(G); -- test à 1
        val := Integer(val);
        my_buf.Set(val);
        put("Producers puts"); 
        put(val,2);
        New_Line (1);
    end Producer;

    task body Consumer is 

        val : INTEGER;

        begin
        my_buf.Get (val);
        put("Consumer gets");
        put(val,2);
        New_Line (1);
    end Consumer;

    Producers : array(1..10) of producer;
    Consumers : array(1..10) of consumer;

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
-- new _ pointeur sur tâche pour les tasks ADA
