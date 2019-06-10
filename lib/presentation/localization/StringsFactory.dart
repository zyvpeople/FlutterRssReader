import 'package:flutter_rss_reader/presentation/localization/Strings.dart';

class StringsFactory {
  static final en = Strings(
    feedsTitle: "Feeds",
    searchHint: "Search",
    feedTitle: "Feed items",
    feedItemTitle: "Feed item",
    browserTitle: "Browser",
    addFeedTitle: "Add feed",
    feedUrlHint: "Feed URL",
    noInternet: "No Internet connection",
    errorSync: "Error sync",
    errorDeleteFeed: "Error delete feed",
    urlIsNotCorrect: "Url is not correct",
    errorCreateFeed: "Error create feed",
    errorDialogTitle: "Error",
    buttonOk: "Ok",
    buttonSearchCancel: "Cancel",
    errorFeedItemDoesNotExist: "Feed item does not exist",
    errorLoadFeedItem: "Error load feed item",
  );

  static final uk = Strings(
    feedsTitle: "Джерела",
    searchHint: "Пошук",
    feedTitle: "Новини",
    feedItemTitle: "Новина",
    browserTitle: "Браузер",
    addFeedTitle: "Додати джерело",
    feedUrlHint: "URL джерела",
    noInternet: "Немає Інтернет з'єднання",
    errorSync: "Помилка синхронізації",
    errorDeleteFeed: "Помилка видалення джерела",
    urlIsNotCorrect: "URL не коректний",
    errorCreateFeed: "Помилка створення",
    errorDialogTitle: "Помилка",
    buttonOk: "Oк",
    buttonSearchCancel: "Відміна",
    errorFeedItemDoesNotExist: "Новина не існує",
    errorLoadFeedItem: "Помилка завантаження новини",
  );
}
