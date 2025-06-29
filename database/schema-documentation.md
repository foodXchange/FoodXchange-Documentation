# FoodXchange Database Schema Documentation
Generated: 2025-06-29 14:51:46

## 🏗️ Database Overview

- **Database Type**: MongoDB (Document-based NoSQL)
- **Hosting**: MongoDB Atlas (Microsoft Azure)
- **Connection**: MongoDB Compass for GUI access
- **Backup**: Automated daily backups

## 📊 Collections Structure

### 1. Users Collection
```javascript
{
  _id: ObjectId,
  email: String (unique, required),
  password: String (hashed),
  profile: {
    firstName: String,
    lastName: String,
    phone: String,
    avatar: String (URL),
    language: String (default: "en"),
    timezone: String
  },
  company: ObjectId (ref: 'Company'),
  role: String (enum: ['buyer', 'supplier', 'admin']),
  permissions: [String],
  authentication: {
    azureId: String,
    lastLogin: Date,
    loginCount: Number,
    isEmailVerified: Boolean,
    emailVerificationToken: String,
    passwordResetToken: String,
    passwordResetExpires: Date
  },
  preferences: {
    notifications: {
      email: Boolean,
      sms: Boolean,
      push: Boolean
    },
    currency: String (default: "USD"),
    units: String (default: "metric")
  },
  status: String (enum: ['active', 'pending', 'suspended']),
  createdAt: Date,
  updatedAt: Date
}
```

### 2. Companies Collection
```javascript
{
  _id: ObjectId,
  type: String (enum: ['buyer', 'supplier', 'both']),
  basicInfo: {
    legalName: String (required),
    tradeName: String,
    registrationNumber: String,
    vatNumber: String,
    website: String,
    logo: String (URL),
    description: String
  },
  addresses: [{
    type: String (enum: ['headquarters', 'warehouse', 'billing']),
    street: String,
    city: String,
    state: String,
    country: String,
    postalCode: String,
    coordinates: {
      type: "Point",
      coordinates: [Number] // [longitude, latitude]
    }
  }],
  contacts: [{
    name: String,
    role: String,
    email: String,
    phone: String,
    isPrimary: Boolean
  }],
  verification: {
    level: String (enum: ['basic', 'verified', 'premium']),
    documents: [{
      type: String,
      url: String,
      uploadedAt: Date,
      verifiedAt: Date,
      status: String (enum: ['pending', 'approved', 'rejected'])
    }],
    score: Number (0-100)
  },
  business: {
    categories: [String],
    certifications: [String],
    languages: [String],
    currencies: [String],
    paymentTerms: [String],
    shippingMethods: [String]
  },
  statistics: {
    totalOrders: Number,
    totalValue: Number,
    rating: Number,
    responseTime: Number // in hours
  },
  status: String (enum: ['active', 'pending', 'suspended']),
  createdAt: Date,
  updatedAt: Date
}
```

### 3. Products Collection
```javascript
{
  _id: ObjectId,
  supplier: ObjectId (ref: 'Company'),
  sku: String (unique),
  status: String (enum: ['active', 'inactive', 'discontinued']),
  
  // Multi-language content
  content: {
    en: {
      name: String,
      description: String,
      keywords: [String],
      specifications: String
    },
    he: { /* Hebrew translations */ },
    de: { /* German translations */ },
    fr: { /* French translations */ }
  },
  
  category: {
    primary: String,
    secondary: [String],
    tags: [String]
  },
  
  specifications: {
    weight: Number,
    weightUnit: String,
    dimensions: {
      length: Number,
      width: Number,
      height: Number,
      unit: String
    },
    packaging: String,
    shelfLife: Number, // days
    storageConditions: String,
    origin: String
  },
  
  compliance: {
    certifications: [{
      type: String,
      authority: String,
      number: String,
      validFrom: Date,
      validUntil: Date,
      documentUrl: String
    }],
    allergens: [String],
    nutritionalInfo: {
      per100g: {
        calories: Number,
        protein: Number,
        carbs: Number,
        fat: Number,
        fiber: Number,
        sugar: Number,
        sodium: Number
      }
    },
    ingredients: [String],
    additives: [String]
  },
  
  pricing: {
    currency: String,
    basePrice: Number,
    minimumOrder: Number,
    priceBreaks: [{
      quantity: Number,
      price: Number
    }],
    validUntil: Date,
    terms: String // FOB, CIF, etc.
  },
  
  media: {
    images: [String], // URLs
    videos: [String], // URLs
    documents: [String] // URLs
  },
  
  availability: {
    inStock: Boolean,
    quantity: Number,
    leadTime: Number, // days
    locations: [String]
  },
  
  seo: {
    searchTerms: [String],
    embeddings: [Number], // AI-generated for semantic search
    boost: Number // Search ranking boost
  },
  
  analytics: {
    views: Number,
    inquiries: Number,
    orders: Number,
    rating: Number,
    reviews: Number
  },
  
  createdAt: Date,
  updatedAt: Date
}
```

### 4. RFQs (Request for Quotation) Collection
```javascript
{
  _id: ObjectId,
  referenceNumber: String (unique),
  buyer: ObjectId (ref: 'Company'),
  status: String (enum: ['draft', 'published', 'closed', 'awarded']),
  
  details: {
    title: String,
    description: String,
    category: String,
    products: [{
      name: String,
      specifications: Object,
      quantity: Number,
      unit: String,
      targetPrice: Number,
      notes: String
    }],
    totalValue: Number,
    currency: String
  },
  
  requirements: {
    certifications: [String],
    qualityStandards: [String],
    packagingRequirements: String,
    labelingRequirements: String,
    deliveryTerms: String,
    paymentTerms: [String],
    sampleRequired: Boolean
  },
  
  delivery: {
    location: String,
    coordinates: {
      type: "Point",
      coordinates: [Number]
    },
    preferredDate: Date,
    flexibilityDays: Number,
    incoterm: String
  },
  
  timeline: {
    publishedAt: Date,
    deadline: Date,
    questionDeadline: Date,
    awardDate: Date,
    deliveryDate: Date
  },
  
  responses: [{
    supplier: ObjectId (ref: 'Company'),
    submittedAt: Date,
    status: String (enum: ['submitted', 'withdrawn', 'shortlisted', 'awarded']),
    response: {
      products: [{
        name: String,
        price: Number,
        availability: String,
        notes: String
      }],
      totalValue: Number,
      deliveryTime: Number,
      validUntil: Date,
      terms: String,
      attachments: [String]
    }
  }],
  
  aiAnalysis: {
    processedAt: Date,
    keywords: [String],
    matchingCriteria: Object,
    suggestedSuppliers: [{
      supplier: ObjectId,
      score: Number,
      reasons: [String]
    }],
    marketPrice: Number,
    recommendations: [String]
  },
  
  attachments: [String],
  
  createdAt: Date,
  updatedAt: Date
}
```

### 5. Orders Collection
```javascript
{
  _id: ObjectId,
  orderNumber: String (unique),
  rfq: ObjectId (ref: 'RFQ'),
  buyer: ObjectId (ref: 'Company'),
  supplier: ObjectId (ref: 'Company'),
  status: String (enum: ['pending', 'confirmed', 'shipped', 'delivered', 'cancelled']),
  
  items: [{
    product: ObjectId (ref: 'Product'),
    name: String,
    sku: String,
    quantity: Number,
    unit: String,
    unitPrice: Number,
    totalPrice: Number,
    specifications: Object
  }],
  
  pricing: {
    subtotal: Number,
    taxes: Number,
    shipping: Number,
    total: Number,
    currency: String
  },
  
  delivery: {
    address: Object,
    method: String,
    estimatedDate: Date,
    actualDate: Date,
    trackingNumber: String,
    carrier: String
  },
  
  payment: {
    method: String,
    terms: String,
    status: String (enum: ['pending', 'paid', 'overdue']),
    dueDate: Date,
    paidDate: Date,
    invoiceNumber: String
  },
  
  documents: [{
    type: String,
    url: String,
    uploadedAt: Date
  }],
  
  timeline: [{
    action: String,
    timestamp: Date,
    user: ObjectId,
    notes: String
  }],
  
  createdAt: Date,
  updatedAt: Date
}
```

## 🔍 Indexes for Performance

### Search Indexes
```javascript
// Text search across products
db.products.createIndex({
  "content.en.name": "text",
  "content.en.description": "text",
  "category.tags": "text"
});

// Geospatial for location-based queries
db.companies.createIndex({ "addresses.coordinates": "2dsphere" });

// Compound indexes for common queries
db.rfqs.createIndex({ "buyer": 1, "status": 1, "timeline.deadline": 1 });
db.orders.createIndex({ "supplier": 1, "status": 1, "createdAt": -1 });
```

## 🔄 Data Relationships

1. **Users** → **Companies** (Many-to-One)
2. **Companies** → **Products** (One-to-Many)
3. **Companies** → **RFQs** (One-to-Many as buyers)
4. **RFQs** → **Orders** (One-to-Many)
5. **Products** → **Orders** (Many-to-Many through order items)

## 🛡️ Security Considerations

- **Encryption**: All sensitive data encrypted at rest
- **Access Control**: Role-based permissions
- **Audit Trail**: All changes logged with timestamps
- **Data Privacy**: GDPR compliant data handling
- **Backup**: Automated daily backups with 30-day retention

---
Last Updated: 2025-06-29 14:51:46
Database Version: MongoDB 6.0+
Maintainer: Udi Strykowski
