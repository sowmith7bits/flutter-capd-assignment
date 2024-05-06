// Mocks generated by Mockito 5.4.2 from annotations
// in tasks_riverpod/test/mock/presentation/viewmodel/tasklist/filter_kind_viewmodel_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter_riverpod/flutter_riverpod.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:state_notifier/state_notifier.dart' as _i5;
import 'package:tasks_riverpod/presentation/viewmodel/taskslist/filter_kind_viewmodel.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [FilterKindViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockFilterKindViewModel extends _i1.Mock
    implements _i2.FilterKindViewModel {
  MockFilterKindViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onError(_i3.ErrorListener? _onError) => super.noSuchMethod(
        Invocation.setter(
          #onError,
          _onError,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get mounted => (super.noSuchMethod(
        Invocation.getter(#mounted),
        returnValue: false,
      ) as bool);

  @override
  _i4.Stream<_i2.FilterKind> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i4.Stream<_i2.FilterKind>.empty(),
      ) as _i4.Stream<_i2.FilterKind>);

  @override
  _i2.FilterKind get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i2.FilterKind.all,
      ) as _i2.FilterKind);

  @override
  set state(_i2.FilterKind? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.FilterKind get debugState => (super.noSuchMethod(
        Invocation.getter(#debugState),
        returnValue: _i2.FilterKind.all,
      ) as _i2.FilterKind);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  bool isFilteredByAll() => (super.noSuchMethod(
        Invocation.method(
          #isFilteredByAll,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool isFilteredByCompleted() => (super.noSuchMethod(
        Invocation.method(
          #isFilteredByCompleted,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool isFilteredByIncomplete() => (super.noSuchMethod(
        Invocation.method(
          #isFilteredByIncomplete,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool updateShouldNotify(
    _i2.FilterKind? old,
    _i2.FilterKind? current,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateShouldNotify,
          [
            old,
            current,
          ],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i3.RemoveListener addListener(
    _i5.Listener<_i2.FilterKind>? listener, {
    bool? fireImmediately = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
          {#fireImmediately: fireImmediately},
        ),
        returnValue: () {},
      ) as _i3.RemoveListener);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
