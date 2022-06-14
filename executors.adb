with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;

package body Executors is

    function submit(E : Executor; C : Callable_Access) return Future is
    f : Future; --pour tester les specs
    begin
        return f;
    end submit;
end Executors;
