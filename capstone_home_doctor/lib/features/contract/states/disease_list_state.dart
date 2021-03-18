import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DiseaseListState extends Equatable {
  const DiseaseListState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DiseaseListStateInitial extends DiseaseListState {}

class DiseaseListStateLoading extends DiseaseListState {}

class DiseaseListStateFailure extends DiseaseListState {}

class DiseaseListStateSuccess extends DiseaseListState {
  final List<DiseaseDTO> listDisease;
  const DiseaseListStateSuccess({@required this.listDisease});

  @override
  // TODO: implement props
  List<Object> get props => [listDisease];
}

class DiseaseHeartListStateSuccess extends DiseaseListState {
  final List<DiseaseDTO> listDisease;
  const DiseaseHeartListStateSuccess({@required this.listDisease});

  @override
  // TODO: implement props
  List<Object> get props => [listDisease];
}
