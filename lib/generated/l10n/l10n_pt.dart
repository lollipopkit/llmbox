// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Verificar atualizações automaticamente';

  @override
  String get backupTip =>
      'Por favor, certifique-se de que seu arquivo de backup é privado e seguro!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Clique para verificar';

  @override
  String get codeBlock => 'Bloco de código';

  @override
  String get copied => 'Copiado';

  @override
  String get current => 'Atual';

  @override
  String delFmt(Object id, Object type) {
    return 'Excluir $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Confirmar antes de excluir';

  @override
  String emptyFields(Object fields) {
    return '$fields estão vazios';
  }

  @override
  String get emptyTrashTip =>
      '==0, excluir na próxima inicialização. <0 não excluir automaticamente.';

  @override
  String get genChatTitle => 'Gerar título do chat';

  @override
  String get image => 'Imagem';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Link desconhecido: $uri';
  }

  @override
  String get languageName => 'Português';

  @override
  String get license => 'Licença';

  @override
  String get licenseMenuItem => 'Licenças de código aberto';

  @override
  String get manual => 'Manual';

  @override
  String get more => 'Mais';

  @override
  String get myOtherApps => 'Meus outros aplicativos';

  @override
  String get newChat => 'Novo chat';

  @override
  String get passwd => 'Senha';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyTip => 'Este aplicativo não coleta nenhuma informação.';

  @override
  String get rename => 'Renomear';

  @override
  String get share => 'Compartilhar';

  @override
  String get shareFrom => 'Compartilhado de';

  @override
  String get softWrap => 'Quebra de linha suave';

  @override
  String sureRestoreFmt(Object time) {
    return 'Tem certeza de que deseja restaurar o backup ($time)?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflito: não é possível ativar $a e $b ao mesmo tempo';
  }

  @override
  String get text => 'Texto';

  @override
  String get themeColorSeed => 'Semente de cor do tema';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String get untitled => 'Sem título';

  @override
  String get usage => 'Uso';

  @override
  String get user => 'Usuário';

  @override
  String get trash => 'Lixeira';

  @override
  String get startChatTip => 'Escolha um modelo abaixo e diga algo.';

  @override
  String get noProviderKey =>
      'Nenhum provedor tem chave ainda. Adicione uma para começar a conversar.';

  @override
  String get providers => 'Provedores';

  @override
  String providersCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n provedores',
      one: '1 provedor',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Hoje';

  @override
  String get earlier => 'Anteriores';

  @override
  String get now => 'agora';

  @override
  String minutesFmt(int n) {
    return '$n min';
  }

  @override
  String hoursFmt(int n) {
    return '$n h';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mensagens',
      one: '1 mensagem',
    );
    return '$_temp0';
  }

  @override
  String get version => 'Versão';

  @override
  String get toolsAndMcp => 'Ferramentas e MCP';

  @override
  String get backToChats => 'Voltar às conversas';

  @override
  String get genChatTitleTip => 'Dá nome à conversa após a primeira resposta';

  @override
  String get scrollOnNewMsg => 'Rolar até o fim a cada nova mensagem';

  @override
  String get scrollAfterSwitch => 'Rolar até o fim ao trocar de conversa';

  @override
  String chatsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n conversas',
      one: '1 conversa',
    );
    return '$_temp0';
  }

  @override
  String get emptyTrashAfter => 'Esvaziar a lixeira após';

  @override
  String get trashTip => 'As conversas excluídas ficam aqui primeiro';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get sync => 'Sincronização';

  @override
  String get syncNow => 'Sincronizar agora';

  @override
  String get syncing => 'Sincronizando…';

  @override
  String get neverSynced => 'Ainda não sincronizado';

  @override
  String lastSyncFmt(String time) {
    return 'Última sincronização: $time';
  }

  @override
  String get syncOffTip =>
      'Ative o LK Cloud, o iCloud ou o WebDAV abaixo para sincronizar automaticamente.';

  @override
  String get backupPassword => 'Senha do backup';

  @override
  String get backupEncrypted => 'Os backups são criptografados com ela';

  @override
  String get backupNotEncrypted =>
      'Não definida: backups em arquivo ficam sem criptografia, e a sincronização exige uma';

  @override
  String get backupEncryptedTip => 'Este backup está criptografado';

  @override
  String get backupPasswordRequired =>
      'Defina uma senha de backup primeiro: backups sincronizados são sempre criptografados';

  @override
  String get passwordWrong => 'Senha incorreta ou backup danificado';

  @override
  String get backupTooNew =>
      'Este backup é de uma versão mais nova do app. Atualize para restaurá-lo.';

  @override
  String get syncAppSettings => 'Sincronizar ajustes do app';

  @override
  String get syncAppSettingsTip =>
      'Tamanho da janela e barra de título ficam por dispositivo';

  @override
  String get webdavManualTip => 'Uma cópia datada ao lado da sincronizada';

  @override
  String get exportFile => 'Exportar para um arquivo';

  @override
  String get importFile => 'Restaurar de um arquivo';

  @override
  String get copyBackup => 'Copiar para a área de transferência';

  @override
  String get pasteBackup => 'Restaurar da área de transferência';

  @override
  String get pullNewChat => 'Puxe para baixo para um novo chat';

  @override
  String get releaseNewChat => 'Solte para um novo chat';

  @override
  String get pullOlderChat => 'Puxe para cima e segure para o chat anterior';

  @override
  String holdOlderChatFmt(String title) {
    return 'Continue segurando: $title';
  }

  @override
  String get shellTool => 'Shell';

  @override
  String get shellToolTip =>
      'Executa comandos neste dispositivo, cada um após sua aprovação';

  @override
  String get linuxEnv => 'Ambiente Linux';

  @override
  String get linuxEnvTip =>
      'Onde o shell roda neste telefone. Ele não vê os arquivos do próprio telefone.';

  @override
  String linuxInstallTip(String distro, String version, int size) {
    return 'Baixar $distro $version, $size MB?';
  }

  @override
  String linuxRemoveTip(String name) {
    return 'Excluir $name e tudo o que foi instalado nele?';
  }

  @override
  String get linuxInUse => 'Há um comando em execução nele';

  @override
  String get linuxNone => 'Não instalado';

  @override
  String get syncChats => 'Sincronizar conversas';

  @override
  String get syncAi => 'Sincronizar modelos, ferramentas e memória';

  @override
  String get syncSecrets => 'Sincronizar chaves de API e segredos MCP';

  @override
  String get syncPasswordMismatch =>
      'A senha de backup não abre a chave desta sincronização: outro dispositivo a alterou';

  @override
  String get syncTooNew =>
      'Sincronizado de uma versão mais nova: atualize para continuar sincronizando';

  @override
  String syncRefused(String reason) {
    return 'O LK Cloud recusou a sincronização ($reason)';
  }

  @override
  String get rotateSyncKey => 'Substituir chave de sincronização';
}
