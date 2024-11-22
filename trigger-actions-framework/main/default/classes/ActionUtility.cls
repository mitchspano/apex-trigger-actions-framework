/**
 * Utilities for managing actions.
 *
 * Allows for the retrieval of the current user's permissions only once during the entire transaction
 * Consolidates code that is shared between MetadataTriggerHandler and FinalizerHandler classes
 */

public with sharing class ActionUtility {
    @TestVisible
    public static Set<String> userPermissions {
        get {
            if (userPermissions == null) {
                userPermissions = new Set<String>();

                List<PermissionSetAssignment> permSets = [
                    SELECT AssigneeId, Assignee.FirstName, PermissionSetId, PermissionSet.Name
                    FROM PermissionSetAssignment
                    WHERE AssigneeId = :UserInfo.getUserId()
                ];
                Set<Id> permSetIds = new Set<Id>();
                for (PermissionSetAssignment psa : permSets) {
                    permSetIds.add(psa.PermissionSetId);
                }
                List<CustomPermission> customPerms = [
                    SELECT DeveloperName, MasterLabel, NamespacePrefix
                    FROM CustomPermission
                    WHERE Id IN (SELECT SetupEntityId FROM SetupEntityAccess WHERE ParentId IN :permSetIds)
                ];
                for (CustomPermission cp : customPerms) {
                    String qualifiedPerm = String.isBlank(cp.NamespacePrefix)
                        ? cp.DeveloperName
                        : cp.NamespacePrefix + '__' + cp.DeveloperName;
                    userPermissions.add(qualifiedPerm);
                }
            }
            return userPermissions;
        }
        private set;
    }

    public static boolean isNotBypassed(String requiredPermission, String bypassPermission) {
        return !((requiredPermission != null && userPermissions.contains(requiredPermission)) ||
        (bypassPermission != null && !userPermissions.contains(bypassPermission)));
    }

    public static Object getActionInstance(String className) {
        String namespace = '';
        System.Type actionType = Type.forName(className);
        /** Type.forName(fullyQualifiedName) allowed some messyness and ambiguity in dealing with namespace
         *   If config does not provide the correct namespace (likely if upgrading from older versions of this framework) we need to fallback in two scenarios
         *     - package and class namespaced but namespace wasn't specified
         *     - namespace is actually in the class field in the form namespace.classname
         */
        // try shared Namespace
        if (actionType == null) {
            // Get the namespace of the current class.
            String[] parts = String.valueOf(ActionUtility.class).split('\\.', 2);
            namespace = parts.size() == 2 ? parts[0] : '';

            // try again with the new namespace
            actionType = Type.forName(namespace, className);
        }
        // try namespace in Class_Name field
        if (actionType == null) {
            String[] parts = className.split('\\.', 2);
            if (parts.size() == 2) {
                namespace = parts[0];
                className = parts[1];
                actionType = Type.forName(namespace, className);
            }
        }
        Object dynamicInstance = actionType.newInstance();
        return dynamicInstance;
    }
}
