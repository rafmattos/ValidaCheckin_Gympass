# ValidaCheckin_Gympass
Exemplo de como validar Checkin na API do Gympass usando Delphi


https://developers.gympass.com/product/access-control-api/1.0/sandbox
Exemplo feito em delphi, para validar o checkin do aluno se realmente ele pode entrar na academia.



Como deve ser Usado:

o ato de fazer checkin do aluno, é informar a academia de que ele tem um plano válido, que o plano dele tem acesso aquela atividade e que ele está próximo da atividade e quer executar. Feito isso, o sistema integrado deve perguntar para a Gympass (ENDPOINT VALIDATE) se o aluno em questão tem diária valida, e se a Gympass responder positivo, então, nesse momento você pode liberar a catraca