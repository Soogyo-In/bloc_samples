part of 'calender_bloc.dart';

sealed class CalenderEvent {}

final class CalenderEventInitialized extends CalenderEvent {}

final class CalenderEventUpdated extends CalenderEvent {}
