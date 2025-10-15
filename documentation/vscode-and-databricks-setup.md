# Guía de Configuración: VS Code + GitHub + Databricks Free Edition (Workspace host)

## 1) Requisitos previos

- **Cuenta en Databricks Free Edition** (antes “Community Edition”). Accede al workspace desde el navegador; la URL debe verse como:
  - `https://<algo>.cloud.databricks.com/?o=<workspace_id>`
  - **Host del workspace** = `https://<algo>.cloud.databricks.com` (sin `?o=...`).
- **VS Code** instalado.
- **Extensiones VS Code**:
  - _Databricks_ (ID: `databricks.databricks`).
  - _Python_, _Jupyter_, _Pylance_, _Black_ (recomendadas).
- **Python** (sugerido 3.10.x por paridad con runtimes comunes).
- **Repo local** clonado con tu contenido.

> Nota: En Free Edition aplican límites de cómputo y funciones. Ver **Limitaciones de Free Edition** en la documentación oficial.

## 2) Crear un **Personal Access Token (PAT)** en tu workspace

1. Ingresa a tu workspace en el navegador (host como `https://<algo>.cloud.databricks.com`).
2. Menú superior derecho → **User Settings** → **Developer** → **Access Tokens**.
3. Clic en **Generate New Token**. Copia el token y guárdalo en un gestor seguro.

> El PAT se asocia **a ese workspace**. Si usas otro workspace, genera otro PAT.

## 3) Configurar la **conexión en VS Code** (extensión Databricks)

1. Abre VS Code → panel lateral **Databricks**.
2. En _CONFIGURATION_, clic en **Create configuration**.
3. Completa los campos:
   - **Connection name**: nombre libre (ej. `CE-personal`).
   - **Host**: **usa el host del workspace** (sin parámetros):
     `https://<algo>.cloud.databricks.com`
   - **Token**: pega tu **PAT**.
   - **Default Workspace folder (opcional)**: una ruta en tu workspace, por ejemplo
     `/Users/<tu_correo>/Courses/Databricks-Intro/`
4. Guarda. Deberías ver en el panel de Databricks el **árbol del Workspace** (Users, Shared, etc.).

> **Importante:** La extensión espera el **host del workspace** (no `https://accounts.cloud.databricks.com`).

## 4) Crear/Seleccionar el **Remote Folder** del proyecto

- En la sección **Remote Folder** del panel Databricks, define la carpeta remota que representará tu proyecto, por ejemplo:
  - `/Workspace/Users/<tu_correo>/Courses/Databricks-Intro/`
- Esta carpeta es donde se subirán/descargarán los archivos al Workspace.

## 5) Sincronización (Sync) local ↔ remoto

- En **Remote Folder** verás un ícono de _play/stop_.
  - **Start synchronization**: inicia la sincronización del contenido del **Local Folder** al **Remote Folder** (y viceversa, según el modo).
  - **Stop synchronization**: detiene la sincronización.
- Recomendación: Mantén **STOPPED** y sube archivos de forma controlada (Upload), o usa sync solo cuando sepas qué quieres reflejar en el Workspace.

> La extensión trabaja mejor con **directorios de workspace creados por ella misma**. Evita apuntar a carpetas remotas no gestionadas por la extensión.

## 6) Seleccionar **Cluster** (Attach / Select a cluster)

- Desde el panel (opción **Select a cluster**), elige el **cluster** o **SQL warehouse** donde ejecutarás código o lanzarás jobs.
- En Free Edition verás opciones limitadas (clúster “single node” o serverless). Si no aparece ninguno, crea uno desde el navegador en **Compute** y vuelve a VS Code para seleccionarlo.

> La selección de cluster permite a la extensión: asociar ejecución remota, mostrar el runtime, y/o lanzar scripts/notebooks como jobs.

## 7) Problemas comunes y solución

- **Invalid host / no conecta**: verifica que el host sea el del workspace (formato `https://<algo>.cloud.databricks.com`, sin `?o=`).
- **401/403**: token expirado o mal pegado. Genera un PAT nuevo.
- **No aparece el cluster**: crea el cluster en el navegador (**Compute**) y refresca VS Code.
- **Sync no refleja cambios**: detén/arranca sync; revisa que el _Remote Folder_ sea el correcto y gestionado por la extensión.
- **Databricks Connect**: requiere **Unity Catalog habilitado** y compatibilidad de runtime. Free Edition suele **no cumplir** esos requisitos; por tanto, **no es recomendable** configurarlo en CE.

---

# Checklist de Validación y Diagnóstico

Antes de iniciar las sesiones, valida los siguientes puntos:

| Elemento               | Descripción                           | Estado Esperado                                   | Verificación                    |
| ---------------------- | ------------------------------------- | ------------------------------------------------- | ------------------------------- |
| **Host**               | URL del workspace sin `?o=`           | Ej.: `https://dbc-xxxx.cloud.databricks.com`      | Archivo `.databricks/config`    |
| **Token (PAT)**        | Token activo asociado a ese workspace | No expirado                                       | `User Settings → Access Tokens` |
| **Local Folder**       | Carpeta raíz de tu proyecto local     | Ej.: `/Users/<usuario>/Desktop/Databricks-Course` | Panel Databricks VS Code        |
| **Remote Folder**      | Carpeta remota dentro del Workspace   | `/Workspace/Users/<email>/Courses/...`            | Panel Databricks VS Code        |
| **Cluster**            | Cluster seleccionado (o creado)       | “Single Node” activo                              | Panel Databricks o UI web       |
| **Sync State**         | Sincronización controlada             | `STOPPED` o `RUNNING` (según caso)                | Panel Databricks VS Code        |
| **Python Environment** | Intérprete local activo               | `.venv` o similar                                 | VS Code barra inferior derecha  |

---

# Descripción visual del panel Databricks en VS Code

El panel **Databricks** de VS Code muestra la estructura y estado de conexión entre tu entorno local y el workspace remoto. Cada sección tiene un propósito específico:

| Elemento                | Propósito / Uso                                                                                                                                                                   |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Local Folder**        | Indica la carpeta raíz local del proyecto (fuentes, notebooks, data).                                                                                                             |
| **Target**              | Define el entorno de despliegue activo (`dev`, `staging`, `prod`). En Free Edition se usa típicamente `dev`.                                                                      |
| **Auth Type (Profile)** | Perfil configurado con el host y token en `.databricks/config`. Define las credenciales de acceso.                                                                                |
| **Select a cluster**    | Permite vincular el proyecto a un clúster remoto o SQL Warehouse para ejecución.                                                                                                  |
| **Remote Folder**       | Carpeta espejo dentro del Workspace remoto de Databricks. Muestra la ruta `/Workspace/...`.                                                                                       |
| **Sync State**          | Indica si la sincronización local ↔ remota está activa (`RUNNING`) o detenida (`STOPPED`).                                                                                        |
| **Python Environment**  | Verifica la relación entre el entorno Python local y el compute remoto. Incluye: <ul><li>Attach a cluster</li><li>Active Environment (.venv)</li><li>Databricks Connect</li></ul> |

---

# Referencias complementarias

- Documentación oficial: _"Connect VS Code to your Databricks workspace"_ (Databricks Docs).
- Guía de autenticación mediante **Personal Access Token (PAT)**.
- Manual de **Databricks Asset Bundles** (para proyectos profesionales).
- _Databricks Connect_ y sus limitaciones en Free Edition (requiere Unity Catalog).
- Comunidad oficial: [community.databricks.com](https://community.databricks.com/).
