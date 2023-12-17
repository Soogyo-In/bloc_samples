import 'package:bloc_samples/repository/calender_repository.dart';
import 'package:bloc_samples/repository/memo_repository.dart';
import 'package:bloc_samples/repository/weather_repository.dart';
import 'package:bloc_samples/scoped_state_bloc/bloc/scoped_state_bloc.dart';
import 'package:bloc_samples/widget/calender.dart';
import 'package:bloc_samples/widget/memo_list.dart';
import 'package:bloc_samples/widget/weather_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 장점
// 1. bloc 을 여럿 만들 필요 없어 손이 덜감.
// 2. bloc 간 통신에 대해 고민하지 않아도 됨.
// 3. 한 화면의 동작을 한 bloc 에서 볼 수 있음.
//
// 단점
// 1. state 가 UI 구성에 맞춰서 작성되기 때문에 Bloc 이 UI 에 간접적인 의존성을 가짐
// 2. copyWith 시 state 에 null 값을 넣기 위해선 파라미터를 함수로 바꾸거나 freezed 같은 패키지를 사용해야함
// 3. 상태 반영 외의 UI 동작(다이얼로그, 스낵바, 내비게이션 등) 의 처리가 마땅치 않음. 아래의 예제도 불필요한 State 클래스를 추가해서 해결함.

class ScopedStateBlocPage extends StatelessWidget {
  const ScopedStateBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScopedStateBloc(
        calenderRepository: context.read<CalenderRepository>(),
        memoRepository: context.read<MemoRepository>(),
        weatherRepository: context.read<WeatherRepository>(),
      )..add(ScopedStateEventInitialized()),
      child: BlocListener<ScopedStateBloc, ScopedStateState>(
        listener: _blocListener,
        child: Scaffold(
          appBar: AppBar(title: const Text('Scoped state bloc')),
          body: Column(
            children: [
              BlocSelector<ScopedStateBloc, ScopedStateState, WeatherState>(
                selector: (state) => state.weather,
                builder: (context, state) => WeatherPanel(
                  humidity: state.humidity,
                  temperature: state.temperature,
                  weather: state.weather,
                ),
              ),
              const SizedBox(height: 16.0),
              BlocSelector<ScopedStateBloc, ScopedStateState, CalenderState>(
                selector: (state) => state.calender,
                builder: (context, state) =>
                    Calender(todosPerDate: state.todosPerDate),
              ),
              const SizedBox(height: 16.0),
              BlocSelector<ScopedStateBloc, ScopedStateState, MemoListState>(
                selector: (state) => state.memoList,
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

  void _blocListener(BuildContext context, ScopedStateState state) {
    if (state.initialized) return;

    if (state.weather.temperature.isNegative) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('영하입니다. ${state.weather.temperature} °C'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }

    if (state is ScopedStateStateCalender) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('일정이 갱신되었습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    if (state is ScopedStateStateMemoAdded) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('메모가 추가되었습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _onMemoConfirmed({
    required BuildContext context,
    required String memo,
  }) {
    context.read<ScopedStateBloc>().add(ScopedStateEventMemoAdded(memo));
  }

  void _onMemoConvertedToTodo({
    required BuildContext context,
    required String group,
    required String title,
  }) {
    context
        .read<ScopedStateBloc>()
        .add(ScopedStateEventMemoConvertedToTodo(memo: title, group: group));
  }
}
