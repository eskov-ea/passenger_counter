import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final ScrollController _controller = ScrollController();

  final List<bool> _isOpenEntity = [false, false, false];
  final List<bool> _isOpenSuit = [false, false];

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(scrollController: _controller, child: Text('Помощь', style: AppStyles.mainTitleTextStyle)),
        body: Container(
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 100),
                _entityFAQBlock(),
                const SizedBox(height: 40),
                _suiteFAQBlock()
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _suiteFAQBlock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Работа с номерами',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
          ExpansionPanelList(
            expansionCallback: (i, isOpen) => setState(() => _isOpenSuit[i] = isOpen),
            dividerColor: Colors.white,
            expandIconColor: AppColors.textMain,
            children: [
              ExpansionPanel(
                  backgroundColor: AppColors.secondary2,
                  isExpanded: _isOpenSuit[0],
                  headerBuilder: (context, isOpen) {
                    return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Что такое номер?',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textMain),
                        )
                    );
                  },
                  body: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      'Номер - это объект хранящий информацию о конкретном месте на корабле. '
                      'На одно место может быть добавлен один Пассажир ( и ребенок Пассажира и только один). ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
              ),
              ExpansionPanel(
                  backgroundColor: AppColors.secondary2,
                  isExpanded: _isOpenSuit[1],
                  headerBuilder: (context, isOpen) {
                    return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Включение / отключение',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textMain),
                        )
                    );
                  },
                  body: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      'Если по техническим причинам заселение пассажира на конкретное место / места необходимо '
                      'ограничить - такое место можно отключить. Отключенное место перестанет появляться в списке доступных '
                      'мест, но будет доступно при просмотре старых рейсов. ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _entityFAQBlock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Типы объектов',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
          ExpansionPanelList(
            expansionCallback: (i, isOpen) => setState(() => _isOpenEntity[i] = isOpen),
            dividerColor: Colors.white,
            children: [
              ExpansionPanel(
                backgroundColor: Colors.purple.shade200,
                isExpanded: _isOpenEntity[0],
                headerBuilder: (context, isOpen) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Персона',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  );
                },
                body: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    'Персона - это физическое лицо, человек. Персона не является пассажиром. '
                    'Персона хранит все данные человека, например ФИО, дату рождения, паспортные данные и тд.'
                    'Персону нельзя удалить. При возникновении ошибок в данных - '
                    'Персону можно отредактировать в разделе \r\n[ Все люди - карточка Персоны].',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ),
              ExpansionPanel(
                  backgroundColor: Colors.purple.shade200,
                  isExpanded: _isOpenEntity[1],
                  headerBuilder: (context, isOpen) {
                    return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Рейсы',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        )
                    );
                  },
                  body: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      'Рейс - объект, хранящий информацию о рейсе корабля. '
                      'Рейс включает в себя название (например: Владивосток - Шикотан), дату отправления и дату прибытия (расчетную). '
                      'При запуске приложение, приложение выбирает текущий рейс, текущая дата находится в диапазоне начало-конец рейса. '
                      'Рейс можно удалить в разделе \r\n[ Все рейсы ], сделав свайп влево до появления соответствующей иконки',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
              ),
              ExpansionPanel(
                  backgroundColor: Colors.purple.shade200,
                  isExpanded: _isOpenEntity[2],
                  headerBuilder: (context, isOpen) {
                    return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Пассажир',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        )
                    );
                  },
                  body: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      'Пассажир - это физическое лицо, зарегистрированное на конкретный рейс. '
                      'Пассажир хранит все данные о Персоне на конкретном рейсе, такие как '
                      'данные Персоны, данные рейса, информацию о месте, статусах пассажира.'
                      'Пассажира можно удалить, при этом будут удалены все записи статусов пассажира, '
                      'место будет освобождено. Для удаления необходимо перейти в раздел '
                      '\r\n[ Текущий рейс - Пассажиры ] и сделать свайп влево до появления соответствующей иконки.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
              ),
            ],
          )
        ],

      ),
    );
  }
}
