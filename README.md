# ValidaCheckin_Gympass
Exemplo de como validar Checkin na API do Gympass usando Delphi


https://developers.gympass.com/product/access-control-api/1.0/sandbox
Exemplo feito em delphi, para validar o checkin do aluno se realmente ele pode entrar na academia.



Como deve ser Usado:

o ato de fazer checkin do aluno, � informar a academia de que ele tem um plano v�lido, que o plano dele tem acesso aquela atividade e que ele est� pr�ximo da atividade e quer executar. Feito isso, o sistema integrado deve perguntar para a Gympass (ENDPOINT VALIDATE) se o aluno em quest�o tem di�ria valida, e se a Gympass responder positivo, ent�o, nesse momento voc� pode liberar a catraca