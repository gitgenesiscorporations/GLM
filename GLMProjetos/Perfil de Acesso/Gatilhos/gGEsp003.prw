/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp003 � Autor � George AC Gon�alves  � Data � 09/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp003 � Autor � George AC Gon�alves  � Data � 19/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recupera descri��o do m�dulo                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do m�dulo - Rotina gCADZZJ             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp003()  // Recupera descri��o do m�dulo

aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

gcDsMod := aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(M->ZZJ_CDMOD)})][3]  // recupera descri��o do m�dulo

Return gcDsMod   // retorno da fun��o