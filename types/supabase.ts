export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      analytics_events: {
        Row: {
          created_at: string | null
          event_name: string
          id: string
          properties: Json | null
          session_id: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          event_name: string
          id?: string
          properties?: Json | null
          session_id?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          event_name?: string
          id?: string
          properties?: Json | null
          session_id?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "analytics_events_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      badges: {
        Row: {
          created_at: string | null
          description: string | null
          description_id: string | null
          icon: string
          id: string
          name: string
          name_id: string
          slug: string
          trigger_type: string
          trigger_value: Json | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          description_id?: string | null
          icon: string
          id?: string
          name: string
          name_id: string
          slug: string
          trigger_type: string
          trigger_value?: Json | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          description_id?: string | null
          icon?: string
          id?: string
          name?: string
          name_id?: string
          slug?: string
          trigger_type?: string
          trigger_value?: Json | null
        }
        Relationships: []
      }
      brokerage_recommendations: {
        Row: {
          description: string | null
          display_order: number | null
          id: string
          is_active: boolean | null
          logo_url: string | null
          name: string
          ojk_registered: boolean | null
          product_types: string[] | null
          risk_level: string | null
          slug: string
          url: string
        }
        Insert: {
          description?: string | null
          display_order?: number | null
          id?: string
          is_active?: boolean | null
          logo_url?: string | null
          name: string
          ojk_registered?: boolean | null
          product_types?: string[] | null
          risk_level?: string | null
          slug: string
          url: string
        }
        Update: {
          description?: string | null
          display_order?: number | null
          id?: string
          is_active?: boolean | null
          logo_url?: string | null
          name?: string
          ojk_registered?: boolean | null
          product_types?: string[] | null
          risk_level?: string | null
          slug?: string
          url?: string
        }
        Relationships: []
      }
      certificates: {
        Row: {
          certificate_code: string
          id: string
          issued_at: string | null
          multiplier_achieved: number
          portfolio_value_at_graduation: number
          share_public_id: string | null
          user_id: string
        }
        Insert: {
          certificate_code: string
          id?: string
          issued_at?: string | null
          multiplier_achieved: number
          portfolio_value_at_graduation: number
          share_public_id?: string | null
          user_id: string
        }
        Update: {
          certificate_code?: string
          id?: string
          issued_at?: string | null
          multiplier_achieved?: number
          portfolio_value_at_graduation?: number
          share_public_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "certificates_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      cohort_memberships: {
        Row: {
          cohort_id: string
          id: string
          joined_at: string | null
          user_id: string
        }
        Insert: {
          cohort_id: string
          id?: string
          joined_at?: string | null
          user_id: string
        }
        Update: {
          cohort_id?: string
          id?: string
          joined_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "cohort_memberships_cohort_id_fkey"
            columns: ["cohort_id"]
            isOneToOne: false
            referencedRelation: "cohorts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "cohort_memberships_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      cohorts: {
        Row: {
          created_at: string | null
          created_by: string | null
          id: string
          invite_code: string
          name: string
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          id?: string
          invite_code: string
          name: string
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          id?: string
          invite_code?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "cohorts_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      content_flags: {
        Row: {
          created_at: string | null
          flagged_by: string | null
          id: string
          lesson_id: string | null
          reason: string
          source_id: string | null
          status: string | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          flagged_by?: string | null
          id?: string
          lesson_id?: string | null
          reason: string
          source_id?: string | null
          status?: string | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          flagged_by?: string | null
          id?: string
          lesson_id?: string | null
          reason?: string
          source_id?: string | null
          status?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "content_flags_flagged_by_fkey"
            columns: ["flagged_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_flags_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "content_flags_source_id_fkey"
            columns: ["source_id"]
            isOneToOne: false
            referencedRelation: "sources"
            referencedColumns: ["id"]
          },
        ]
      }
      content_variants: {
        Row: {
          body: Json
          created_at: string | null
          difficulty: string | null
          id: string
          is_active: boolean | null
          last_used_at: string | null
          lesson_id: string
          topic_tag: string | null
          usage_count: number | null
          variant_type: string
        }
        Insert: {
          body: Json
          created_at?: string | null
          difficulty?: string | null
          id?: string
          is_active?: boolean | null
          last_used_at?: string | null
          lesson_id: string
          topic_tag?: string | null
          usage_count?: number | null
          variant_type: string
        }
        Update: {
          body?: Json
          created_at?: string | null
          difficulty?: string | null
          id?: string
          is_active?: boolean | null
          last_used_at?: string | null
          lesson_id?: string
          topic_tag?: string | null
          usage_count?: number | null
          variant_type?: string
        }
        Relationships: [
          {
            foreignKeyName: "content_variants_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
      daily_checkins: {
        Row: {
          checkin_date: string
          created_at: string | null
          id: string
          koin_points_earned: number | null
          user_id: string
          xp_earned: number | null
        }
        Insert: {
          checkin_date?: string
          created_at?: string | null
          id?: string
          koin_points_earned?: number | null
          user_id: string
          xp_earned?: number | null
        }
        Update: {
          checkin_date?: string
          created_at?: string | null
          id?: string
          koin_points_earned?: number | null
          user_id?: string
          xp_earned?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "daily_checkins_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      friend_invites: {
        Row: {
          created_at: string | null
          expires_at: string | null
          id: string
          invite_code: string
          inviter_id: string
          max_uses: number | null
          uses_count: number | null
        }
        Insert: {
          created_at?: string | null
          expires_at?: string | null
          id?: string
          invite_code?: string
          inviter_id: string
          max_uses?: number | null
          uses_count?: number | null
        }
        Update: {
          created_at?: string | null
          expires_at?: string | null
          id?: string
          invite_code?: string
          inviter_id?: string
          max_uses?: number | null
          uses_count?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "friend_invites_inviter_id_fkey"
            columns: ["inviter_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      friendships: {
        Row: {
          addressee_id: string
          created_at: string | null
          id: string
          requester_id: string
          status: string | null
          updated_at: string | null
        }
        Insert: {
          addressee_id: string
          created_at?: string | null
          id?: string
          requester_id: string
          status?: string | null
          updated_at?: string | null
        }
        Update: {
          addressee_id?: string
          created_at?: string | null
          id?: string
          requester_id?: string
          status?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "friendships_addressee_id_fkey"
            columns: ["addressee_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "friendships_requester_id_fkey"
            columns: ["requester_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      holdings: {
        Row: {
          average_cost: number
          created_at: string | null
          current_price: number | null
          id: string
          last_price_updated_at: string | null
          portfolio_id: string
          shares: number
          symbol: string
          updated_at: string | null
        }
        Insert: {
          average_cost?: number
          created_at?: string | null
          current_price?: number | null
          id?: string
          last_price_updated_at?: string | null
          portfolio_id: string
          shares?: number
          symbol: string
          updated_at?: string | null
        }
        Update: {
          average_cost?: number
          created_at?: string | null
          current_price?: number | null
          id?: string
          last_price_updated_at?: string | null
          portfolio_id?: string
          shares?: number
          symbol?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "holdings_portfolio_id_fkey"
            columns: ["portfolio_id"]
            isOneToOne: false
            referencedRelation: "portfolios"
            referencedColumns: ["id"]
          },
        ]
      }
      koin_point_balances: {
        Row: {
          current_balance: number
          lifetime_earned: number
          updated_at: string | null
          user_id: string
        }
        Insert: {
          current_balance?: number
          lifetime_earned?: number
          updated_at?: string | null
          user_id: string
        }
        Update: {
          current_balance?: number
          lifetime_earned?: number
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "koin_point_balances_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      koin_point_transactions: {
        Row: {
          amount: number
          created_at: string | null
          description: string | null
          id: string
          source_id: string | null
          source_type: string
          user_id: string
        }
        Insert: {
          amount: number
          created_at?: string | null
          description?: string | null
          id?: string
          source_id?: string | null
          source_type: string
          user_id: string
        }
        Update: {
          amount?: number
          created_at?: string | null
          description?: string | null
          id?: string
          source_id?: string | null
          source_type?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "koin_point_transactions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_attempts: {
        Row: {
          ai_help_used_count: number | null
          answers_json: Json | null
          attempt_number: number | null
          completed: boolean | null
          completed_at: string | null
          created_at: string | null
          id: string
          lesson_id: string
          max_score: number | null
          score: number | null
          time_spent_seconds: number | null
          user_id: string
        }
        Insert: {
          ai_help_used_count?: number | null
          answers_json?: Json | null
          attempt_number?: number | null
          completed?: boolean | null
          completed_at?: string | null
          created_at?: string | null
          id?: string
          lesson_id: string
          max_score?: number | null
          score?: number | null
          time_spent_seconds?: number | null
          user_id: string
        }
        Update: {
          ai_help_used_count?: number | null
          answers_json?: Json | null
          attempt_number?: number | null
          completed?: boolean | null
          completed_at?: string | null
          created_at?: string | null
          id?: string
          lesson_id?: string
          max_score?: number | null
          score?: number | null
          time_spent_seconds?: number | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "lesson_attempts_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "lesson_attempts_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_media: {
        Row: {
          alt_text: string | null
          created_at: string | null
          display_order: number | null
          id: string
          is_active: boolean | null
          lesson_id: string
          media_type: string
          url: string
        }
        Insert: {
          alt_text?: string | null
          created_at?: string | null
          display_order?: number | null
          id?: string
          is_active?: boolean | null
          lesson_id: string
          media_type: string
          url: string
        }
        Update: {
          alt_text?: string | null
          created_at?: string | null
          display_order?: number | null
          id?: string
          is_active?: boolean | null
          lesson_id?: string
          media_type?: string
          url?: string
        }
        Relationships: [
          {
            foreignKeyName: "lesson_media_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_progress: {
        Row: {
          attempts_count: number | null
          best_score: number | null
          first_completed_at: string | null
          id: string
          last_attempted_at: string | null
          lesson_id: string
          status: string | null
          user_id: string
        }
        Insert: {
          attempts_count?: number | null
          best_score?: number | null
          first_completed_at?: string | null
          id?: string
          last_attempted_at?: string | null
          lesson_id: string
          status?: string | null
          user_id: string
        }
        Update: {
          attempts_count?: number | null
          best_score?: number | null
          first_completed_at?: string | null
          id?: string
          last_attempted_at?: string | null
          lesson_id?: string
          status?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "lesson_progress_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "lesson_progress_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_reviews: {
        Row: {
          approved_to_publish: boolean | null
          compliance_status: string | null
          created_at: string | null
          factual_accuracy_status: string | null
          id: string
          indonesia_context_status: string | null
          lesson_id: string
          notes: string | null
          review_date: string | null
          reviewer_name: string | null
          reviewer_role: string | null
          source_verification_status: string | null
          updated_at: string | null
        }
        Insert: {
          approved_to_publish?: boolean | null
          compliance_status?: string | null
          created_at?: string | null
          factual_accuracy_status?: string | null
          id?: string
          indonesia_context_status?: string | null
          lesson_id: string
          notes?: string | null
          review_date?: string | null
          reviewer_name?: string | null
          reviewer_role?: string | null
          source_verification_status?: string | null
          updated_at?: string | null
        }
        Update: {
          approved_to_publish?: boolean | null
          compliance_status?: string | null
          created_at?: string | null
          factual_accuracy_status?: string | null
          id?: string
          indonesia_context_status?: string | null
          lesson_id?: string
          notes?: string | null
          review_date?: string | null
          reviewer_name?: string | null
          reviewer_role?: string | null
          source_verification_status?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "lesson_reviews_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: true
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_sources: {
        Row: {
          citation_label: string | null
          display_order: number | null
          id: string
          is_primary: boolean | null
          lesson_id: string
          relevance_type: string | null
          source_id: string
        }
        Insert: {
          citation_label?: string | null
          display_order?: number | null
          id?: string
          is_primary?: boolean | null
          lesson_id: string
          relevance_type?: string | null
          source_id: string
        }
        Update: {
          citation_label?: string | null
          display_order?: number | null
          id?: string
          is_primary?: boolean | null
          lesson_id?: string
          relevance_type?: string | null
          source_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "lesson_sources_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "lesson_sources_source_id_fkey"
            columns: ["source_id"]
            isOneToOne: false
            referencedRelation: "sources"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_triggers: {
        Row: {
          condition_json: Json
          created_at: string | null
          id: string
          is_active: boolean | null
          lesson_id: string
          max_times_triggered: number | null
          priority: number | null
          trigger_type: string
        }
        Insert: {
          condition_json: Json
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          lesson_id: string
          max_times_triggered?: number | null
          priority?: number | null
          trigger_type: string
        }
        Update: {
          condition_json?: Json
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          lesson_id?: string
          max_times_triggered?: number | null
          priority?: number | null
          trigger_type?: string
        }
        Relationships: [
          {
            foreignKeyName: "lesson_triggers_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
      lesson_versions: {
        Row: {
          ai_assist_context: string | null
          common_mistake: string | null
          concept_body: string | null
          created_at: string | null
          created_by: string | null
          id: string
          indonesian_example: string | null
          is_published: boolean | null
          lesson_id: string
          quiz_data: Json | null
          review_status: string | null
          reviewed_at: string | null
          reviewed_by: string | null
          summary: string | null
          title: string
          title_id: string
          updated_at: string | null
          version_number: number
          why_this_matters: string | null
        }
        Insert: {
          ai_assist_context?: string | null
          common_mistake?: string | null
          concept_body?: string | null
          created_at?: string | null
          created_by?: string | null
          id?: string
          indonesian_example?: string | null
          is_published?: boolean | null
          lesson_id: string
          quiz_data?: Json | null
          review_status?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          summary?: string | null
          title: string
          title_id: string
          updated_at?: string | null
          version_number: number
          why_this_matters?: string | null
        }
        Update: {
          ai_assist_context?: string | null
          common_mistake?: string | null
          concept_body?: string | null
          created_at?: string | null
          created_by?: string | null
          id?: string
          indonesian_example?: string | null
          is_published?: boolean | null
          lesson_id?: string
          quiz_data?: Json | null
          review_status?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          summary?: string | null
          title?: string
          title_id?: string
          updated_at?: string | null
          version_number?: number
          why_this_matters?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "lesson_versions_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "lesson_versions_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
      lessons: {
        Row: {
          ai_assist_context: string | null
          common_mistake: string | null
          concept_body: string | null
          created_at: string | null
          difficulty: string
          estimated_minutes: number | null
          id: string
          indonesian_example: string | null
          is_published: boolean | null
          jurisdiction: string | null
          lesson_number: number
          prerequisite_lesson_id: string | null
          quiz_data: Json | null
          review_status: string | null
          reviewed_at: string | null
          reviewed_by: string | null
          slug: string
          summary: string | null
          title: string
          title_id: string
          topic_id: string | null
          updated_at: string | null
          why_this_matters: string | null
          xp_reward: number
        }
        Insert: {
          ai_assist_context?: string | null
          common_mistake?: string | null
          concept_body?: string | null
          created_at?: string | null
          difficulty: string
          estimated_minutes?: number | null
          id?: string
          indonesian_example?: string | null
          is_published?: boolean | null
          jurisdiction?: string | null
          lesson_number: number
          prerequisite_lesson_id?: string | null
          quiz_data?: Json | null
          review_status?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          slug: string
          summary?: string | null
          title: string
          title_id: string
          topic_id?: string | null
          updated_at?: string | null
          why_this_matters?: string | null
          xp_reward?: number
        }
        Update: {
          ai_assist_context?: string | null
          common_mistake?: string | null
          concept_body?: string | null
          created_at?: string | null
          difficulty?: string
          estimated_minutes?: number | null
          id?: string
          indonesian_example?: string | null
          is_published?: boolean | null
          jurisdiction?: string | null
          lesson_number?: number
          prerequisite_lesson_id?: string | null
          quiz_data?: Json | null
          review_status?: string | null
          reviewed_at?: string | null
          reviewed_by?: string | null
          slug?: string
          summary?: string | null
          title?: string
          title_id?: string
          topic_id?: string | null
          updated_at?: string | null
          why_this_matters?: string | null
          xp_reward?: number
        }
        Relationships: [
          {
            foreignKeyName: "lessons_prerequisite_lesson_id_fkey"
            columns: ["prerequisite_lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "lessons_topic_id_fkey"
            columns: ["topic_id"]
            isOneToOne: false
            referencedRelation: "topics"
            referencedColumns: ["id"]
          },
        ]
      }
      levels: {
        Row: {
          badge_icon: string | null
          description: string | null
          id: number
          name: string
          name_id: string
          xp_required: number
        }
        Insert: {
          badge_icon?: string | null
          description?: string | null
          id: number
          name: string
          name_id: string
          xp_required: number
        }
        Update: {
          badge_icon?: string | null
          description?: string | null
          id?: number
          name?: string
          name_id?: string
          xp_required?: number
        }
        Relationships: []
      }
      market_data: {
        Row: {
          close_price: number
          company_name: string | null
          created_at: string | null
          high_price: number | null
          id: string
          low_price: number | null
          open_price: number | null
          source_url: string | null
          symbol: string
          trade_date: string
          volume: number | null
        }
        Insert: {
          close_price: number
          company_name?: string | null
          created_at?: string | null
          high_price?: number | null
          id?: string
          low_price?: number | null
          open_price?: number | null
          source_url?: string | null
          symbol: string
          trade_date: string
          volume?: number | null
        }
        Update: {
          close_price?: number
          company_name?: string | null
          created_at?: string | null
          high_price?: number | null
          id?: string
          low_price?: number | null
          open_price?: number | null
          source_url?: string | null
          symbol?: string
          trade_date?: string
          volume?: number | null
        }
        Relationships: []
      }
      notifications_queue: {
        Row: {
          body: string | null
          created_at: string | null
          data_json: Json | null
          id: string
          notification_type: string
          read_at: string | null
          scheduled_for: string | null
          sent_at: string | null
          title: string
          user_id: string
        }
        Insert: {
          body?: string | null
          created_at?: string | null
          data_json?: Json | null
          id?: string
          notification_type: string
          read_at?: string | null
          scheduled_for?: string | null
          sent_at?: string | null
          title: string
          user_id: string
        }
        Update: {
          body?: string | null
          created_at?: string | null
          data_json?: Json | null
          id?: string
          notification_type?: string
          read_at?: string | null
          scheduled_for?: string | null
          sent_at?: string | null
          title?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "notifications_queue_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      portfolios: {
        Row: {
          cash_balance: number
          created_at: string | null
          graduated_at: string | null
          graduation_multiplier: number | null
          id: string
          starting_cash: number
          status: string | null
          total_value: number
          updated_at: string | null
          user_id: string
        }
        Insert: {
          cash_balance?: number
          created_at?: string | null
          graduated_at?: string | null
          graduation_multiplier?: number | null
          id?: string
          starting_cash?: number
          status?: string | null
          total_value?: number
          updated_at?: string | null
          user_id: string
        }
        Update: {
          cash_balance?: number
          created_at?: string | null
          graduated_at?: string | null
          graduation_multiplier?: number | null
          id?: string
          starting_cash?: number
          status?: string | null
          total_value?: number
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "portfolios_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          age_range: string | null
          avatar_url: string | null
          created_at: string | null
          display_name: string
          financial_goal: string | null
          id: string
          onboarding_completed: boolean | null
          preferred_language: string | null
          updated_at: string | null
          username: string | null
        }
        Insert: {
          age_range?: string | null
          avatar_url?: string | null
          created_at?: string | null
          display_name: string
          financial_goal?: string | null
          id: string
          onboarding_completed?: boolean | null
          preferred_language?: string | null
          updated_at?: string | null
          username?: string | null
        }
        Update: {
          age_range?: string | null
          avatar_url?: string | null
          created_at?: string | null
          display_name?: string
          financial_goal?: string | null
          id?: string
          onboarding_completed?: boolean | null
          preferred_language?: string | null
          updated_at?: string | null
          username?: string | null
        }
        Relationships: []
      }
      recommended_resources: {
        Row: {
          created_at: string | null
          description: string | null
          description_id: string | null
          display_order: number | null
          id: string
          is_active: boolean | null
          lesson_id: string
          resource_type: string
          title: string
          title_id: string
          url: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          description_id?: string | null
          display_order?: number | null
          id?: string
          is_active?: boolean | null
          lesson_id: string
          resource_type: string
          title: string
          title_id: string
          url?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          description_id?: string | null
          display_order?: number | null
          id?: string
          is_active?: boolean | null
          lesson_id?: string
          resource_type?: string
          title?: string
          title_id?: string
          url?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "recommended_resources_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
        ]
      }
      sources: {
        Row: {
          created_at: string | null
          id: string
          isbn: string | null
          language: string | null
          last_checked_at: string | null
          local_title: string | null
          localization_notes: string | null
          organization: string
          publication_year: number | null
          source_code: string
          source_tier: number
          source_type: string
          status: string | null
          title: string
          trust_notes: string | null
          url: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          isbn?: string | null
          language?: string | null
          last_checked_at?: string | null
          local_title?: string | null
          localization_notes?: string | null
          organization: string
          publication_year?: number | null
          source_code: string
          source_tier: number
          source_type: string
          status?: string | null
          title: string
          trust_notes?: string | null
          url?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          isbn?: string | null
          language?: string | null
          last_checked_at?: string | null
          local_title?: string | null
          localization_notes?: string | null
          organization?: string
          publication_year?: number | null
          source_code?: string
          source_tier?: number
          source_type?: string
          status?: string | null
          title?: string
          trust_notes?: string | null
          url?: string | null
        }
        Relationships: []
      }
      streak_events: {
        Row: {
          created_at: string | null
          event_type: string
          id: string
          streak_days_at_event: number | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          event_type: string
          id?: string
          streak_days_at_event?: number | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          event_type?: string
          id?: string
          streak_days_at_event?: number | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "streak_events_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      streaks: {
        Row: {
          current_streak_days: number | null
          last_completed_on: string | null
          longest_streak_days: number | null
          streak_freezes_available: number | null
          streak_status: string | null
          user_id: string
        }
        Insert: {
          current_streak_days?: number | null
          last_completed_on?: string | null
          longest_streak_days?: number | null
          streak_freezes_available?: number | null
          streak_status?: string | null
          user_id: string
        }
        Update: {
          current_streak_days?: number | null
          last_completed_on?: string | null
          longest_streak_days?: number | null
          streak_freezes_available?: number | null
          streak_status?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "streaks_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      topics: {
        Row: {
          color: string | null
          created_at: string | null
          display_order: number | null
          icon: string | null
          id: string
          name: string
          name_id: string
          slug: string
        }
        Insert: {
          color?: string | null
          created_at?: string | null
          display_order?: number | null
          icon?: string | null
          id?: string
          name: string
          name_id: string
          slug: string
        }
        Update: {
          color?: string | null
          created_at?: string | null
          display_order?: number | null
          icon?: string | null
          id?: string
          name?: string
          name_id?: string
          slug?: string
        }
        Relationships: []
      }
      trades: {
        Row: {
          created_at: string | null
          id: string
          lot_count: number
          portfolio_id: string
          price: number
          shares: number
          symbol: string
          total_amount: number
          trade_type: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          lot_count: number
          portfolio_id: string
          price: number
          shares: number
          symbol: string
          total_amount: number
          trade_type: string
        }
        Update: {
          created_at?: string | null
          id?: string
          lot_count?: number
          portfolio_id?: string
          price?: number
          shares?: number
          symbol?: string
          total_amount?: number
          trade_type?: string
        }
        Relationships: [
          {
            foreignKeyName: "trades_portfolio_id_fkey"
            columns: ["portfolio_id"]
            isOneToOne: false
            referencedRelation: "portfolios"
            referencedColumns: ["id"]
          },
        ]
      }
      user_badges: {
        Row: {
          badge_id: string
          earned_at: string | null
          id: string
          user_id: string
        }
        Insert: {
          badge_id: string
          earned_at?: string | null
          id?: string
          user_id: string
        }
        Update: {
          badge_id?: string
          earned_at?: string | null
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_badges_badge_id_fkey"
            columns: ["badge_id"]
            isOneToOne: false
            referencedRelation: "badges"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_badges_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      user_lesson_recommendations: {
        Row: {
          created_at: string | null
          dismissed: boolean | null
          id: string
          lesson_id: string
          reason: string
          trigger_id: string | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          dismissed?: boolean | null
          id?: string
          lesson_id: string
          reason: string
          trigger_id?: string | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          dismissed?: boolean | null
          id?: string
          lesson_id?: string
          reason?: string
          trigger_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_lesson_recommendations_lesson_id_fkey"
            columns: ["lesson_id"]
            isOneToOne: false
            referencedRelation: "lessons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_lesson_recommendations_trigger_id_fkey"
            columns: ["trigger_id"]
            isOneToOne: false
            referencedRelation: "lesson_triggers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_lesson_recommendations_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      user_mastery: {
        Row: {
          created_at: string | null
          id: string
          last_updated: string | null
          lessons_completed: number | null
          mastery_score: number | null
          topic_id: string
          total_lessons: number | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          last_updated?: string | null
          lessons_completed?: number | null
          mastery_score?: number | null
          topic_id: string
          total_lessons?: number | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          last_updated?: string | null
          lessons_completed?: number | null
          mastery_score?: number | null
          topic_id?: string
          total_lessons?: number | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_mastery_topic_id_fkey"
            columns: ["topic_id"]
            isOneToOne: false
            referencedRelation: "topics"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_mastery_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      user_risk_profiles: {
        Row: {
          id: string
          recommended_lesson_ids: string[] | null
          risk_label: string | null
          risk_score: number | null
          traits_json: Json | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          id?: string
          recommended_lesson_ids?: string[] | null
          risk_label?: string | null
          risk_score?: number | null
          traits_json?: Json | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          id?: string
          recommended_lesson_ids?: string[] | null
          risk_label?: string | null
          risk_score?: number | null
          traits_json?: Json | null
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_risk_profiles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      user_settings: {
        Row: {
          notifications_enabled: boolean | null
          show_on_leaderboard: boolean | null
          streak_reminder_time: string | null
          trade_onboarding_completed: boolean | null
          updated_at: string | null
          user_id: string
          weekly_report_enabled: boolean | null
        }
        Insert: {
          notifications_enabled?: boolean | null
          show_on_leaderboard?: boolean | null
          streak_reminder_time?: string | null
          trade_onboarding_completed?: boolean | null
          updated_at?: string | null
          user_id: string
          weekly_report_enabled?: boolean | null
        }
        Update: {
          notifications_enabled?: boolean | null
          show_on_leaderboard?: boolean | null
          streak_reminder_time?: string | null
          trade_onboarding_completed?: boolean | null
          updated_at?: string | null
          user_id?: string
          weekly_report_enabled?: boolean | null
        }
        Relationships: [
          {
            foreignKeyName: "user_settings_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      watchlists: {
        Row: {
          created_at: string | null
          id: string
          symbol: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          symbol: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          symbol?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "watchlists_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      weekly_leaderboard_snapshots: {
        Row: {
          created_at: string | null
          id: string
          koin_points_this_week: number | null
          rank_friends: number | null
          rank_global: number | null
          user_id: string
          week_start: string
          xp_this_week: number | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          koin_points_this_week?: number | null
          rank_friends?: number | null
          rank_global?: number | null
          user_id: string
          week_start: string
          xp_this_week?: number | null
        }
        Update: {
          created_at?: string | null
          id?: string
          koin_points_this_week?: number | null
          rank_friends?: number | null
          rank_global?: number | null
          user_id?: string
          week_start?: string
          xp_this_week?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "weekly_leaderboard_snapshots_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      xp_events: {
        Row: {
          created_at: string | null
          id: string
          source_id: string | null
          source_type: string
          user_id: string
          xp_amount: number
        }
        Insert: {
          created_at?: string | null
          id?: string
          source_id?: string | null
          source_type: string
          user_id: string
          xp_amount: number
        }
        Update: {
          created_at?: string | null
          id?: string
          source_id?: string | null
          source_type?: string
          user_id?: string
          xp_amount?: number
        }
        Relationships: [
          {
            foreignKeyName: "xp_events_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      accept_friend_invite: {
        Args: { p_invite_code: string; p_user_id: string }
        Returns: Json
      }
      award_koin_points: {
        Args: {
          p_amount: number
          p_description?: string
          p_source_id?: string
          p_source_type: string
          p_user_id: string
        }
        Returns: Json
      }
      check_in_streak: { Args: { p_user_id: string }; Returns: Json }
      complete_lesson: {
        Args: {
          p_answers_json: Json
          p_lesson_id: string
          p_max_score: number
          p_quiz_correct: boolean
          p_score: number
          p_time_spent_seconds: number
          p_user_id: string
        }
        Returns: Json
      }
      create_friend_invite: { Args: { p_user_id: string }; Returns: Json }
      execute_trade: {
        Args: {
          p_lot_count: number
          p_symbol: string
          p_trade_type: string
          p_user_id: string
        }
        Returns: Json
      }
      get_latest_market_data: {
        Args: never
        Returns: {
          close_price: number
          company_name: string
          id: string
          symbol: string
          trade_date: string
          volume: number
        }[]
      }
      get_weekly_leaderboard: {
        Args: { p_scope: string; p_user_id: string }
        Returns: Json
      }
      recompute_streak_status: { Args: { p_user_id: string }; Returns: Json }
      seed_next_market_data: {
        Args: { p_trade_date?: string }
        Returns: {
          close_price: number
          symbol: string
        }[]
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const
