import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:platinum_world_management_system/src/core/constants/app_technical_strings.dart';

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
  void goToHome() => go(AppTechnicalRoutes.root);

  /// Navega a la pestaña de Inventario con o sin enfoque de ubicación específica o contenedor.
  void goToInventory({String? focusNodeId, String? containerId}) {
    final queryParams = <String, String>{};
    if (focusNodeId != null && focusNodeId.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramFocusNodeId] = focusNodeId;
    }
    if (containerId != null && containerId.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramContainerId] = containerId;
    }
    if (queryParams.isNotEmpty) {
      final uri = Uri(path: AppTechnicalRoutes.inventory, queryParameters: queryParams);
      go(uri.toString());
    } else {
      go(AppTechnicalRoutes.inventory);
    }
  }

  /// Navega a la pestaña de Ubicaciones (Inventario con cortina de ubicaciones abierta).
  void goToLocations({String? focusNodeId, String? containerId}) {
    final queryParams = <String, String>{};
    if (focusNodeId != null && focusNodeId.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramFocusNodeId] = focusNodeId;
    }
    if (containerId != null && containerId.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramContainerId] = containerId;
    }
    if (queryParams.isNotEmpty) {
      final uri = Uri(path: AppTechnicalRoutes.locations, queryParameters: queryParams);
      go(uri.toString());
    } else {
      go(AppTechnicalRoutes.locations);
    }
  }

  /// Navega a la pestaña del Catálogo Maestro sin clonar la vista.
  void goToCatalog({String? speciesId, String? filter}) {
    final queryParams = <String, String>{};
    if (speciesId != null && speciesId.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramSpeciesId] = speciesId;
    }
    if (filter != null && filter.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramFilter] = filter;
    }

    if (queryParams.isNotEmpty) {
      final uri = Uri(path: AppTechnicalRoutes.catalog, queryParameters: queryParams);
      go(uri.toString());
    } else {
      go(AppTechnicalRoutes.catalog);
    }
  }

  /// Navega a la pestaña de Búsqueda y Consola SQL.
  void goToSearch({String? query, String? scope}) {
    final queryParams = <String, String>{};
    if (query != null && query.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramQ] = query;
    }
    if (scope != null && scope.isNotEmpty) {
      queryParams[AppTechnicalRoutes.paramScope] = scope;
    }

    if (queryParams.isNotEmpty) {
      final uri = Uri(path: AppTechnicalRoutes.search, queryParameters: queryParams);
      go(uri.toString());
    } else {
      go(AppTechnicalRoutes.search);
    }
  }

  // =========================================================================
  // PANTALLAS DE DETALLE JERÁRQUICO (Stack Push via context.push)
  // =========================================================================

  /// Empuja la pantalla de detalle de una instancia/entidad específica.
  void pushEntityDetail(String entityId) => push(AppTechnicalRoutes.entityDetailPath(entityId));

  /// Empuja la pantalla de detalle maestro de una especie del catálogo.
  void pushSpeciesDetail(String speciesId) => push(AppTechnicalRoutes.catalogDetailPath(speciesId));


  /// Empuja el Centro de Control de Calidad y Auditorías.
  void pushControlCenter() => push(AppTechnicalRoutes.controlCenter);

  /// Empuja la pantalla de Ajustes.
  void pushSettings() => push(AppTechnicalRoutes.settings);

  /// Empuja la pantalla de Notificaciones.
  void pushNotifications() => push(AppTechnicalRoutes.notifications);
}
