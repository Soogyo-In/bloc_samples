import 'package:bloc_samples/multi_bloc/bloc/calender_bloc.dart';
import 'package:bloc_samples/multi_bloc/bloc/memo_list_bloc.dart';
import 'package:bloc_samples/multi_bloc/bloc/weather_bloc.dart';
import 'package:bloc_samples/repository/calender_repository.dart';
import 'package:bloc_samples/repository/memo_repository.dart';
import 'package:bloc_samples/repository/weather_repository.dart';
import 'package:bloc_samples/widget/calender.dart';
import 'package:bloc_samples/widget/memo_list.dart';
import 'package:bloc_samples/widget/weather_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 장점
// 1. bloc 의 비즈니스 집중도가 높음
// 2. bloc 이 관심사 외의 상태를 가지지 않음
//
// 단점
// 1. 손이 많이 간다.
// 2. bloc 간 통신을 고려해야한다.
// 3. 한 화면의 동작을 여러 bloc 을 돌아다니며 파악해야함.

class MultiBlocPage extends StatelessWidget {
  const MultiBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(context.read<WeatherRepository>())
            ..add(WeatherEventInitialized()),
        ),
        BlocProvider(
          create: (context) => CalenderBloc(context.read<CalenderRepository>())
            ..add(CalenderEventInitialized()),
        ),
        BlocProvider(
          create: (context) => MemoListBloc(
            calenderRepository: context.read<CalenderRepository>(),
            memoRepository: context.read<MemoRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Multi bloc')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocConsumer<WeatherBloc, WeatherState>(
                listener: _weatherBlocListener,
                builder: (context, state) => WeatherPanel(
                  humidity: state.humidity,
                  temperature: state.temperature,
                  weather: state.weather,
                ),
              ),
              const SizedBox(height: 16.0),
              BlocConsumer<CalenderBloc, CalenderState>(
                listener: _calenderBlocListener,
                builder: (context, state) => Calender(
                  todosPerDate: state.todosPerDate,
                ),
              ),
              const SizedBox(height: 16.0),
              BlocConsumer<MemoListBloc, MemoListState>(
                listener: _memoListBlocListener,
                builder: (context, state) => Expanded(
                  child: MemoList(
                    memos: state.memos,
                    onMemoSubmitted: (memo) => _onMemoConfirmed(
                      context: context,
                      memo: memo,
                    ),
                    onConvertedToTodo: (memo) => _onMemoConvertedToTodo(
                      context: context,
                      group: memo.group,
                      title: memo.title,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _weatherBlocListener(BuildContext context, WeatherState state) {
    if (state.temperature.isNegative) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('영하입니다. ${state.temperature} °C'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _calenderBlocListener(BuildContext context, CalenderState state) {
    if (state.initialized) return;

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('일정이 갱신되었습니다.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _memoListBlocListener(BuildContext context, MemoListState state) {
    if (state.convertedToTodo) {
      context.read<CalenderBloc>().add(CalenderEventUpdated());
      return;
    }

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('메모가 추가되었습니다.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onMemoConfirmed({
    required BuildContext context,
    required String memo,
  }) {
    context.read<MemoListBloc>().add(MemoListEventAdded(memo));
  }

  void _onMemoConvertedToTodo({
    required BuildContext context,
    required String group,
    required String title,
  }) {
    context
        .read<MemoListBloc>()
        .add(MemoListEventConvertedToTodo(memo: title, group: group));
  }
}
