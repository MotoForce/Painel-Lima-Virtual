-- IAE: instalação isolada da infraestrutura de PROGRESSO (sem certificação)
-- Destino verificado: projeto piagfpnjiwpngbikkkfp (Painel-Lima-Virtual)
-- Execute somente após backup e conferência do projeto no SQL Editor.
-- Não altera tabelas sqlpro_*, alcance_*, pwa_*; não cria contas.
BEGIN;
DO $check$
BEGIN
 IF to_regclass('public.iae_student_state') IS NOT NULL THEN
  RAISE EXCEPTION 'iae_student_state já existe: não instalar automaticamente. Inspecione estrutura antes.';
 END IF;
 IF to_regprocedure('public.get_student_state()') IS NOT NULL OR to_regprocedure('public.save_student_state(jsonb)') IS NOT NULL THEN
  RAISE EXCEPTION 'Funções IAE já existem: revisar antes de prosseguir.';
 END IF;
END $check$;
CREATE TABLE public.iae_student_state (
 user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
 data jsonb NOT NULL DEFAULT '{}'::jsonb,
 updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.iae_student_state ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.iae_student_state FROM PUBLIC, anon, authenticated;
-- Acesso exclusivo por RPC validada via auth.uid(); não liberar tabela diretamente.
CREATE FUNCTION public.get_student_state() RETURNS jsonb
 LANGUAGE sql STABLE SECURITY DEFINER SET search_path = '' AS $$
 SELECT CASE WHEN auth.uid() IS NULL THEN NULL
 ELSE coalesce((SELECT s.data FROM public.iae_student_state s WHERE s.user_id=auth.uid()), '{}'::jsonb) END;
 $$;
CREATE FUNCTION public.save_student_state(p_state jsonb) RETURNS boolean
 LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
BEGIN
 IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Autenticação obrigatória'; END IF;
 IF p_state IS NULL OR jsonb_typeof(p_state) <> 'object' OR pg_column_size(p_state) > 100000 THEN
  RAISE EXCEPTION 'Dados de progresso inválidos ou muito grandes';
 END IF;
 INSERT INTO public.iae_student_state (user_id, data) VALUES (auth.uid(), p_state)
 ON CONFLICT (user_id) DO UPDATE SET data=EXCLUDED.data, updated_at=now();
 RETURN true;
END $$;
REVOKE ALL ON FUNCTION public.get_student_state(), public.save_student_state(jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_state(), public.save_student_state(jsonb) TO authenticated;
COMMIT;
NOTIFY pgrst, 'reload schema';
-- IMPORTANTE: progresso enviado pelo navegador NÃO comprova horas/avaliações.
-- Este script não autoriza emissão de certificados nem instala módulos administrativos.
