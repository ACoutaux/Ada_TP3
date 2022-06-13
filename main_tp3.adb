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
    current_time : Time := Clock;

    period : Duration := 2.0;

    read_length : INTEGER;   
    My_File  : File_Type; 
    Items : Shared_Items_Access;

    mode : Sem_Type;
    
    task type Producer is 
       entry Initialize (P : Duration; D : Time; S : Sem_Type);
    end Producer;

    task type Consumer is
       entry Initialize (P : Duration; D : Time; S : Sem_Type);
    end Consumer;
    
    task body Producer is

        G : Generator;
        F : Float;
        Value : Integer;
        Period : Duration;
        Deadline : Time;
        Semantic : Sem_Type;
        
    begin
        Reset (G); -- Faire une seule fois
        accept Initialize (P : Duration; D : Time; S : Sem_Type) do
            Period := P;
            Deadline := D;
            Semantic := S;
        end Initialize;
       
        loop
            F := Random (G);
            Value := Integer(10.0 * F);
            Deadline := Deadline + Period;
            case Semantic is
                when Blocking =>
                    Items.Put (Value);
                    put("Producer puts ");
                    put(Value);
                    New_Line (2);
                when Non_Blocking =>
                    Add (Items, Value);    
                    put("Producer puts ");
                    put(Value);
                    New_Line (2);
                when Timed =>
                    Offer (Items,Value, Deadline);
                    put("Producer puts ");
                    put(Value);
                    New_Line (2);
            end case;
            delay(1.0);
        end loop;
    end Producer;


    task body Consumer is

        Period : Duration;
        Deadline : Time;
        Semantic : Sem_Type;
        Value : Integer;
        
    begin
        accept Initialize (P : Duration; D : Time; S : Sem_Type) do
            Period := P;
            Deadline := D;
            Semantic := S;
        end Initialize;
       
        loop
            Deadline := Deadline + Period;
            case Semantic is
                when Blocking =>
                    Items.Get(Value);
                    put("Consumer gets ");
                    put(Value);
                    New_Line (2);                 
                when Non_Blocking =>
                    Value := Remove(Items); 
                    put("Consumer gets ");
                    put(Value);
                    New_Line (2);
                when Timed =>
                    Value := Poll(Items, Deadline);
                    put("Consumer gets ");
                    put(Value);
                    New_Line (2);
            end case;
            delay(1.0);
        end loop;
    end Consumer;

    type Consumer_Access is access Consumer;
    type Producer_Access is access Producer;
     
    P : Producer_Access;
    C : Consumer_Access;

    number_consumers : Natural;
    number_producters : Natural;
    mode_index : INTEGER;
    Wrong_Mode_Exception : exception;

begin

    -- Lecture de la taille du buffer depuis le fichier de parametres
    Open (My_File, In_File, Name => "params.txt");
    Get (My_File, read_length); -- taille du buffer 1e ligne fichier params
    Put("Length read of buffer is ");
    Put(read_length,2);
    New_Line (1);
    Get(My_File, number_producters); -- nombre de producteurs 2e ligne fichier params
    Get(My_File, number_consumers); -- nombre de consommateurs 3e ligne fichier params
    Get(My_File, mode_index); -- mode non-blocked(0), blocked(1), timed(2) 4e ligne fichier params
    Close (My_File);
    Items := new Shared_Items (read_length - 1);

    case mode_index is 
        when 0 =>
            mode := Non_Blocking;
        when 1 =>
            mode := Blocking;
        when 2 =>
            mode := Timed;
        when others =>
            raise Wrong_Mode_Exception;
    end case;
    
    for I in 1 .. number_producters loop
        P := new Producer;
        P.Initialize (period, current_time, mode);    
    end loop;
    for I in 1 .. number_consumers loop
        C := new Consumer;
        C.Initialize (period, current_time, mode);
    end loop;

end main_tp3;

-- -------------  MODIFS -------------------------
-- Importation params ligne de commande
