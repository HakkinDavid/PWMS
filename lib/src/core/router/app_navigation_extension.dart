import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension on [BuildContext] that standardizes navigation across the app.
///
/// Top-level shell branches use [go] to seamlessly switch between tabs without
/// duplicating or cloning screens in the navigation stack.
/// Deep detail screens use [push] to open on top of the root navigator.
extension AppNavigationExtension on BuildContext {
  // =========================================================================
  // SECCIONES PRINCIPALES (Shell Branch Switching via context.go)
  // =========================================================================

  /// Navega a la pestaña de Inicio.
  void goToHome() => go('/');

  /// Navega a la pestaña de Inventario con o sin enfoque de ubicación específica o contenedor.
  void goToInventory({String? focusNodeId, String? containerId}) {
    final queryParams = <String, String>{};
    if (focusNodeId != null && focusNodeId.isNotEmpty) {
      queryParams['focusNodeId'] = focusNodeId;
    }
    if (containerId != null && containerId.isNotEmpty) {
      queryParams['containerId'] = containerId;
    }
    if (queryParams.isNotEmpty) {
      final uri = Uri(path: '/inventory', queryParameters: queryParams);
      go(uri.toString());
    } else {
      go('/inventory');
    }
  }

  /// Navega a la pestaña de Ubicaciones (Inventario con cortina de ubicaciones abierta).
  void goToLocations({String? focusNodeId, String? containerId}) {
    final queryParams = <String, String>{};
    if (focusNodeId != null && focusNodeId.isNotEmpty) {
      queryParams['focusNodeId'] = focusNodeId;
    }
    if (containerId != null && containerId.isNotEmpty) {
      queryParams['containerId'] = containerId;
    }
    if (queryParams.isNotEmpty) {
      final uri = Uri(path: '/locations', queryParameters: queryParams);
      go(uri.toString());
    } else {
      go('/locations');
    }
  }

  /// Navega a la pestaña del Catálogo Maestro sin clonar la vista.
  void goToCatalog({String? speciesId, String? filter}) {
    final queryParams = <String, String>{};
    if (speciesId != null && speciesId.isNotEmpty) {
      queryParams['speciesId'] = speciesId;
    }
    if (filter != null && filter.isNotEmpty) {
      queryParams['filter'] = filter;
    }

    if (queryParams.isNotEmpty) {
      final uri = Uri(path: '/catalog', queryParameters: queryParams);
      go(uri.toString());
    } else {
      go('/catalog');
    }
  }

  /// Navega a la pestaña de Búsqueda y Consola SQL.
  void goToSearch({String? query, String? scope}) {
    final queryParams = <String, String>{};
    if (query != null && query.isNotEmpty) {
      queryParams['q'] = query;
    }
    if (scope != null && scope.isNotEmpty) {
      queryParams['scope'] = scope;
    }

    if (queryParams.isNotEmpty) {
      final uri = Uri(path: '/search', queryParameters: queryParams);
      go(uri.toString());
    } else {
      go('/search');
    }
  }

  // =========================================================================
  // PANTALLAS DE DETALLE JERÁRQUICO (Stack Push via context.push)
  // =========================================================================

  /// Empuja la pantalla de detalle de una instancia/entidad específica.
  void pushEntityDetail(String entityId) => push('/entity/$entityId');

  /// Empuja la pantalla de detalle maestro de una especie del catálogo.
  void pushSpeciesDetail(String speciesId) => push('/catalog/$speciesId');

  /// Empuja la pantalla de detalle de un grupo de instancias.
  void pushGroupedInstanceDetail(String speciesId, {String? effectiveLocationId}) {
    final locParam = (effectiveLocationId != null && effectiveLocationId.isNotEmpty)
        ? '&locId=$effectiveLocationId'
        : '';
    push('/grouped-instance-detail?speciesId=$speciesId$locParam');
  }

  /// Empuja el Centro de Control de Calidad y Auditorías.
  void pushControlCenter() => push('/control-center');

  /// Empuja la pantalla de Ajustes.
  void pushSettings() => push('/settings');

  /// Empuja la pantalla de Notificaciones.
  void pushNotifications() => push('/notifications');
}
