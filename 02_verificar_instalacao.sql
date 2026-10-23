-- Somente leitura, confirma instalação sem expor dados dos alunos
SELECT to_regclass('public.iae_student_state') AS tabela_de_progresso,
       to_regprocedure('public.get_student_state()') AS funcao_leitura,
       to_regprocedure('public.save_student_state(jsonb)') AS funcao_escrita;
SELECT relrowsecurity AS rls_habilitada FROM pg_class WHERE oid=to_regclass('public.iae_student_state');
SELECT routine_name FROM information_schema.routines WHERE routine_schema='public'
 AND routine_name IN ('get_student_state','save_student_state') ORDER BY routine_name;
