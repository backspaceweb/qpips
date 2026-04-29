# QuantumPips Project Architecture & Handover Report

## 1. Executive Summary
QuantumPips is a Flutter-based management console for trading accounts. It synchronizes trading data between a specialized Trading Server (REST API) and a Cloud Database (Supabase) to provide a unified dashboard for account monitoring, risk management, and registration.

## 2. Tech Stack
- **Framework:** Flutter (Targeting Desktop/Web/Mobile)
- **State Management:** `Provider` & `ProxyProvider`
- **Networking:** `Chopper` with `Swagger` code generation
- **Backend/DB:** `Supabase` (Cloud sync and persistence)
- **Local Storage:** `SharedPreferences`
- **Environment:** `flutter_dotenv` for API key management

## 3. Project Structure
The project follows a **Feature-first Clean Architecture**:

- `lib/core/`
    - `api/`: Chopper client configuration (`api_client_provider.dart`) and generated models from Swagger.
    - `interceptors/`: `ApiKeyInterceptor` for automated header injection.
- `lib/repositories/`
    - `trading_repository.dart`: The core business engine. Manages the lifecycle of trading accounts and synchronizes state between the Trading Server and Supabase.
    - `auth_repository.dart`: Manages user sessions (currently in mock state).
- `lib/features/`
    - `registration/`: UI for onboarding MT4, MT5, cTrader, DxTrade, TradeLocker, and MatchTrade accounts.
    - `dashboard/`: The main control center showing account metrics, active accounts, and the price ticker.

## 4. Key Workflows

### Data Synchronization
The app uses a "Server-as-Source, Cloud-as-Store" model:
1. Fetch active accounts from the Trading Server.
2. Compare with records in Supabase.
3. Update Supabase to reflect the current server state while preserving user-defined metadata (like activation status).

### Account Registration
- Supports 6+ trading platforms.
- Collects credentials and routes them to platform-specific endpoints via the `TradingRepository`.
- Automatically registers the new account into the Supabase cloud sync once confirmed by the server.

## 5. Current Development Status
- [x] **Core Infrastructure:** Chopper/Supabase setup complete.
- [x] **Account Management:** CRUD operations for trading accounts fully functional.
- [x] **Cloud Sync:** Automated synchronization between Server and Supabase implemented.
- [~] **Authentication:** Currently using hardcoded Admin login; Supabase Auth integration is the next milestone.
- [~] **Price Feed:** UI implemented; currently using simulated ticker data.

## 6. How to Help (Developer Instructions)
When contributing to this project:
1. **Models:** Do not edit files in `lib/core/api/generated/` manually. Use `dart run build_runner build`.
2. **Logic:** Business logic must reside in the `Repository` layer, not in the UI.
3. **Environment:** Ensure a `.env` file exists with the required `API_KEY`.
