with Protected_Buffer;
use Protected_Buffer;
with Ada.Text_IO; 
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

procedure main_tp3 is 

    x,y,z,read_length,cpt : INTEGER;   
    My_File  : FILE_TYPE; 

begin

    x:=0;
    cpt := 1;

    Open (My_File, In_File, Name => "params.txt");
    Get (My_File, read_length);
    Put("Length read of buffer is ");
    Put(read_length,3);
    New_Line (1);
    Close (My_File);

    Protected_Buffer.Length := read_length;

    loop 
        if cpt > Protected_Buffer.Length
            then exit ;      
            else 
                Shared_Items.Set(x+cpt);
                cpt := cpt+1;
        end if ;
    end loop ;

    cpt := 1;

    loop 
        if cpt > Protected_Buffer.Length
            then exit ;      
            else 
                Shared_Items.Get(z);
                Put(z);
                New_Line (1);
                cpt := cpt+1;
        end if ;
    end loop ;

-- new _ pointeur sur tâche pour les tasks ADA


end main_tp3;