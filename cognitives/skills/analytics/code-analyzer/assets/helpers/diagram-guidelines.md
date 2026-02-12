# Diagram Guidelines

Guidelines for selecting and generating Mermaid diagrams in code-analyzer reports.

## Diagram Type Selection

| Diagram Type | When to Use | Purpose |
|-------------|-------------|---------|
| **Flowchart** | Always | Visualize primary execution flow through the module |
| **Sequence Diagram** | When module communicates with 2+ external actors | Show inter-module communication and message flow |
| **Class Diagram** | When module has 3+ classes/interfaces | Display internal structure and relationships |
| **C4 Context** | When module is a major system component | Provide system-level view of module's role |

## Complexity-Based Guidelines

Don't generate diagrams for trivial modules. Match diagram complexity to module complexity:

- **Simple module** (1-2 files, single responsibility): Flowchart only
- **Medium module** (3-10 files, multiple responsibilities): Flowchart + Sequence
- **Complex module** (10+ files, system-critical): Flowchart + Sequence + Class/C4

## Flowchart Examples

### Basic Execution Flow

````markdown
```mermaid
flowchart TD
    A[Entry Point] --> B{Validation}
    B -->|Valid| C[Process]
    B -->|Invalid| D[Error Response]
    C --> E[Database Write]
    E --> F[Response]
```
````

### Complex Flow with Error Handling

````markdown
```mermaid
flowchart TD
    Start[Receive Request] --> Validate{Validate Input}
    Validate -->|Valid| Auth{Authenticate}
    Validate -->|Invalid| Error1[400 Bad Request]

    Auth -->|Success| Process[Process Request]
    Auth -->|Failure| Error2[401 Unauthorized]

    Process --> DB{Database Operation}
    DB -->|Success| Emit[Emit Event]
    DB -->|Failure| Retry{Retry?}

    Retry -->|Yes| Process
    Retry -->|No| Error3[500 Internal Error]

    Emit --> Success[200 OK]
```
````

## Sequence Diagram Examples

### Simple Service Communication

````markdown
```mermaid
sequenceDiagram
    participant Client
    participant Service
    participant Database

    Client->>Service: POST /resource
    Service->>Database: Query data
    Database-->>Service: Data result
    Service-->>Client: 200 OK
```
````

### Multi-Service Interaction

````markdown
```mermaid
sequenceDiagram
    participant OS as Order Service
    participant PS as Payment Service
    participant SG as Stripe Gateway
    participant NS as Notification Service

    OS->>PS: POST /payments/charge
    PS->>PS: Validate payment data
    PS->>SG: Create charge
    SG-->>PS: Charge result
    alt Success
        PS-->>OS: 200 OK
        PS--)NS: payment.receipt.ready
    else Failure
        PS-->>OS: 402 Payment Failed
        PS--)NS: payment.failed
    end
```
````

### Event-Driven Communication

````markdown
```mermaid
sequenceDiagram
    participant P as Producer
    participant E as Event Bus
    participant C1 as Consumer 1
    participant C2 as Consumer 2

    P->>E: Emit event.created
    E--)C1: event.created
    E--)C2: event.created
    C1->>C1: Process event
    C2->>C2: Process event
    C1--)E: Emit event.processed
    C2--)E: Emit event.processed
```
````

## Class Diagram Examples

### Basic Class Structure

````markdown
```mermaid
classDiagram
    class PaymentService {
        -gateway: PaymentGateway
        -validator: PaymentValidator
        +processPayment(data)
        +validatePayment(data)
        -handleResult(result)
    }

    class PaymentGateway {
        -stripeClient: Stripe
        +createCharge(amount, method)
        +refund(chargeId)
    }

    class PaymentValidator {
        +validateAmount(amount)
        +validateMethod(method)
        +validateUser(userId)
    }

    PaymentService --> PaymentGateway
    PaymentService --> PaymentValidator
```
````

### Inheritance and Interfaces

````markdown
```mermaid
classDiagram
    class IPaymentGateway {
        <<interface>>
        +createCharge(amount, method)
        +refund(chargeId)
    }

    class StripeGateway {
        -client: Stripe
        +createCharge(amount, method)
        +refund(chargeId)
    }

    class PayPalGateway {
        -client: PayPal
        +createCharge(amount, method)
        +refund(chargeId)
    }

    IPaymentGateway <|.. StripeGateway
    IPaymentGateway <|.. PayPalGateway

    PaymentService --> IPaymentGateway
```
````

## C4 Context Diagram

Use for system-level views of major components.

````markdown
```mermaid
C4Context
    title Payment System Context

    Person(customer, "Customer", "Makes purchases")
    System(platform, "E-commerce Platform", "Handles orders and payments")
    System_Ext(stripe, "Stripe", "Payment gateway")
    System_Ext(email, "Email Service", "Sends receipts")

    Rel(customer, platform, "Places orders")
    Rel(platform, stripe, "Processes payments")
    Rel(platform, email, "Sends receipts")
```
````

## Best Practices

### Do:
- Use clear, descriptive labels for nodes and relationships
- Show the happy path prominently
- Include error handling flows for critical operations
- Use consistent naming conventions across diagrams
- Keep diagrams focused on one aspect (flow, communication, structure)

### Don't:
- Include implementation details (variable names, exact syntax)
- Make diagrams too complex (>15 nodes in a flowchart, >8 actors in sequence)
- Duplicate information across multiple diagrams
- Show trivial flows that don't add understanding
- Use diagrams when prose is clearer

## Diagram Format

Always wrap Mermaid diagrams in code blocks:

````markdown
```mermaid
[diagram content]
```
````

## Accessibility

Add brief text descriptions before complex diagrams:

```markdown
The following sequence diagram shows the payment processing flow when an order is placed. The order service initiates the payment, the payment service validates and processes via Stripe, and the notification service is triggered on completion.

```mermaid
[sequence diagram]
```
```

## Testing Diagrams

Before including a diagram:
1. Verify syntax is correct (Mermaid will render it)
2. Check that it matches the textual analysis
3. Ensure it adds value (not just decoration)
4. Confirm it's readable at typical document widths
